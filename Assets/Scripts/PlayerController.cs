using System;
using System.Collections;
using NUnit.Framework.Internal;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.HID;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour
{
    [Header("Player Stats")]
    public float effectiveSpeed;
    public float dashCost;
    public float GravityNotJumping; // gravity qui maintient le joueur au sol
    public Vector2 dashBoxSize;
    
    [Header("Pushback")]
    public float pushbackForceX = 10f;
    public float pushbackForceY = 6f;
    public float pushbackDuration = 0.15f;

    private bool isPushedBack = false;
    private float pushbackTimer = 0f;
    private Vector2 pushbackVelocity;

    [Header("CoyotEtime")]
    public float coyotETimer;
    public float cototE;

    [Header("Player refs")]
    public InputManager inputManager;
    public CustomInputs playerControls;
    public Rigidbody2D rb;
    private BoxCollider2D selfCollider;
    public PlayerTimer timerController;
    private PlayerBoost playerBoost;
    private PlayerSound playerSound;
    public PlayerPresets activePreset;
    public GlobalTime globalTime;
    private LineRenderer line;
    private Image blackScreen;
    private Color blackScreenColor;
    public Transform respawnPoint;
    
    [Header("Player Debug")]
    public bool isGrounded = true;

    public bool onStation = false;
    public bool isCharging = false;
    private bool isDashing = false;
    public bool isRespawning = false;
    private bool notJumping = true; //check si on doit détecter le sol ou pas
    private float movementUpDown;
    private float movementLeftRight;
    private Vector2 movement;
    public Vector2 StartPos; //pos de départ pour restart

    [Header("Prefabs")] 
    public GameObject bubbleSlow;
    public GameObject bubbleFast;
    
    public bool CanMove = false;
    public int gearChange = 0;
    private float t = 0f;//timer pour isgrounded
    private float GlisseDuree = 0.1f; // Durée pour glisser
    private float GlisseTimer = 0f; // timer pour réactiver la gravité des boosts en l'air
    [HideInInspector] public Vector2 platformVelocity = Vector2.zero;
    private void OnEnable()
    {
        if (playerControls == null)
            playerControls = new CustomInputs();
        
        playerControls.Enable();
    }
    private void OnDisable()
    {
        playerControls.Disable();
    }
    void Start()
    {
        inputManager = FindAnyObjectByType<InputManager>();
        selfCollider = GetComponent<BoxCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        blackScreen = GameObject.FindGameObjectWithTag("BlackScreen").GetComponent<Image>();
        
        playerBoost = GetComponent<PlayerBoost>();
        playerSound = FindObjectOfType<PlayerSound>();
        playerBoost.boostState = BoostStates.Gear2;
        activePreset = playerBoost.ReturnGearSpeed();
        
        timerController = GetComponent<PlayerTimer>();
        timerController.tMult = activePreset.timerMult;
        
        Physics2D.queriesStartInColliders = false;
        Physics2D.gravity = new Vector2(0, -activePreset.slideSpeed);
        
        StartPos = rb.position; //sauvegarde position de départ
        line = GetComponent<LineRenderer>();
        blackScreenColor = Color.black;

        StartCoroutine(StartGame());
    }

    public void MakeJump()
    {
        notJumping = false; //arrêter la détection du sol
        GlisseTimer = 0f;
        Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
        rb.linearVelocity = new Vector2(rb.linearVelocity.x, activePreset.jumpForce);
    }
    
    //private IEnumerator Dash()
    //{
        //isDashing = true;
        //var originalGravity = rb.gravityScale;
        //rb.gravityScale = 0;
        //rb.linearVelocity = Vector2.zero;
        //rb.linearVelocity = playerControls.Player.Direction.ReadValue<Vector2>() * activePreset.dashSpeed;
        //yield return new WaitForSecondsRealtime(activePreset.dashDuration);
        //rb.gravityScale = originalGravity;
        //timerController.t -= dashCost;
        //isDashing = false;
    //}

    public void StartDash()
    {
        //StartCoroutine(Dash());
    }
    public void MakeDash()
    {
        Vector3[] posArray = new Vector3[2];
        Vector2 endPos = playerControls.Player.Direction.ReadValue<Vector2>().normalized;
        RaycastHit2D checkDash = Physics2D.BoxCast(transform.position, dashBoxSize, 0f, endPos, activePreset.airSpeed);
        posArray[0] = transform.position;
            
        if (checkDash)
        {
            endPos = checkDash.point;
        }
        else
        {
            endPos *= activePreset.airSpeed;
            endPos += rb.position;
        }
        // get pos array (points)
        posArray[1] = endPos;
        line.SetPositions(posArray);
            
        //apply positions
        rb.position = endPos;
        if (!timerController.isCharging)
            timerController.t -= dashCost;
    }
    
    public void ChangeGear()
    {
        Debug.Log("Gear Changed");
        if (gearChange == 0)
        {            
            playerBoost.boostState = BoostStates.Gear1;

            if (!isGrounded && rb.linearVelocityY < 0)
            {
                rb.linearVelocity = new Vector2(rb.linearVelocity.x, rb.linearVelocityY * 0.2f);
            }
        }
        else if (gearChange == 1)
            playerBoost.boostState = BoostStates.Gear2;
        else if (gearChange == 2)
            playerBoost.boostState = BoostStates.Gear3;
        activePreset = playerBoost.ReturnGearSpeed();
        timerController.tMult = activePreset.timerMult;
        Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
    }
    private void Update()
    {
        if (!isPushedBack && !isRespawning)
        {
            movementLeftRight = playerControls.Player.Direction.ReadValue<Vector2>().x;
            movementUpDown = playerControls.Player.Direction.ReadValue<Vector2>().y;
        }

        if (timerController.t <= 0 && !isRespawning) StartCoroutine(MakeRespawn());
        
        if (cototE >= 0f)
        {
            cototE -= Time.deltaTime;
        }
        
        movement = new Vector2(movementLeftRight * effectiveSpeed, rb.linearVelocityY);
        
        if (notJumping) IsGrounded(); //Pour régler le problème de détection du sol, quand on saute il redétecte à la frame d'après le sol et sans réactive immédiatement GravityNotJumping
        else
        {
            t += Time.deltaTime;
            if (t >= 0.2f)
            {
                notJumping = true;
                t = 0f;
            }
        }
        
        // DEBUG INPUTS
        if (playerControls.DEBUG.AdminGear.WasPressedThisFrame())
        {
            playerBoost.boostState = BoostStates.DEBUG;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
        }
        
        if (playerControls.DEBUG.TimerReset.WasPressedThisFrame())
            timerController.t = timerController.timer;
    }

    void FixedUpdate()
    { 
        if (isPushedBack)
        {
            rb.linearVelocity = new Vector2(pushbackVelocity.x, rb.linearVelocityY);

            pushbackTimer -= Time.fixedDeltaTime;
            if (pushbackTimer <= 0f)
            {
                isPushedBack = false;
            }
            return;
        }
        if (CanMove) 
            rb.linearVelocity = new Vector2(movementLeftRight * effectiveSpeed, rb.linearVelocityY);
        else
        {
            rb.linearVelocity = new Vector2(platformVelocity.x, rb.linearVelocityY);
            Debug.Log(rb.linearVelocity);
        }
    }

    // INFORMATION TAKING
    private void IsGrounded()
    {
        RaycastHit2D hit = Physics2D.BoxCast(transform.position, selfCollider.size, 0f, Vector2.down, 0.2f);
                                                                                                                                            
        Debug.DrawLine(transform.position, hit.point, Color.red);
        if (hit && (hit.collider.CompareTag("Ground") || hit.collider.CompareTag("Moving")))
        {
            Physics2D.gravity = new Vector2(0, -activePreset.slideSpeed); //forcer une gravité pour maintenir le player au sol
            cototE = coyotETimer;
            isGrounded = true;
            effectiveSpeed = activePreset.groundSpeed;
            GlisseTimer = GlisseDuree;
        }
        
        else
        {
            if (GlisseTimer > 0f)
            {
                GlisseTimer -= Time.deltaTime;
                
                Physics2D.gravity = new Vector2(0, -activePreset.slideSpeed);
                isGrounded = true; 
                effectiveSpeed = activePreset.groundSpeed;
            }
            else
            {
                Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
                cototE -= Time.deltaTime;
                isGrounded = false;
                effectiveSpeed = activePreset.airSpeed;
            }
        }
        //if (isDashing)
            //effectiveSpeed = activePreset.dashSpeed;
    }
    
    public void Pushback(Vector2 hitPosition)
    {
        Vector2 dir = ((Vector2)transform.position - hitPosition).normalized;
        
        float x = Mathf.Sign(dir.x) * pushbackForceX;
        float y = pushbackForceY;

        pushbackVelocity = new Vector2(x, y);
        isPushedBack = true;
        pushbackTimer = pushbackDuration;
        notJumping = false;
        t = 0f;
        rb.linearVelocity = pushbackVelocity;
    }
    
    void Respawn()
    {
        playerSound.StartSound();
        Debug.Log("OUTTA TIME !!!");
        // Return
        timerController.t = timerController.timer;
        // Reset
        playerBoost.boostState = BoostStates.Gear2;
        activePreset = playerBoost.ReturnGearSpeed();
        inputManager.ActivateStation.Invoke();
        timerController.tMult = activePreset.timerMult;
        Physics2D.gravity = new Vector2(0, -activePreset.slideSpeed); //forcer une gravité pour maintenir le player au sol
        CanMove = true;
        isRespawning = false;
        // Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
    }

    public IEnumerator MakeRespawn()
    {
        Debug.Log("Respawn");
        isRespawning = true;
        CanMove = false;
        if (transform.parent != null)
            transform.SetParent(null);
        playerSound.Death();
        while (blackScreenColor.a < 1f)
        {
            blackScreenColor.a += Time.deltaTime;
            blackScreen.color = blackScreenColor;
            yield return null;
        }

        if (transform.parent != null)
        {
            transform.SetParent(null);
        }
        rb.position = new Vector2(respawnPoint.position.x, respawnPoint.position.y);
        yield return new WaitForSeconds(1f);
        while (blackScreenColor.a > 0f)
        {
            blackScreenColor.a -= Time.deltaTime;
            blackScreen.color = blackScreenColor;
            yield return null;
        }
        Respawn();

    }

    public IEnumerator StartGame()
    {
        while (blackScreenColor.a > 0f)
        {
            blackScreenColor.a -= Time.deltaTime;
            blackScreen.color = blackScreenColor;
            yield return null;
        }
        rb.position = new Vector2(respawnPoint.position.x, respawnPoint.position.y);
        Respawn();
        CanMove = true;
    }
    public void ExitStation()
    {
        onStation =  false;
        isCharging = false;
    }
    
    // MECHANICS
    // private IEnumerator Dash()
    // {
    //     isDashing = true;
    //     var originalGravity = rb.gravityScale;
    //     rb.gravityScale = 0;
    //     rb.linearVelocity = Vector2.zero;
    //     rb.linearVelocityX = movementLeftRight * activePreset.dashSpeed;
    //     yield return new WaitForSecondsRealtime(activePreset.dashDuration);
    //     rb.gravityScale = originalGravity;
    //     isDashing = false;
    // }
}