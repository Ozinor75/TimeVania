using System;
using System.Collections;
using NUnit.Framework.Internal;
using UnityEditor;
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
    public float coyotE;

    [Header("Player refs")]
    public InputManager inputManager;
    public CustomInputs playerControls;
    public Rigidbody2D rb;
    private CapsuleCollider2D selfCollider;
    public PlayerTimer timerController;
    private PlayerBoost playerBoost;
    private PlayerSound playerSound;
    public PlayerPresets activePreset;
    public GlobalTime globalTime;
    private LineRenderer line;
    private Image blackScreen;
    private Color blackScreenColor;
    public Transform respawnPoint;
    public Transform tempRespawn;
    
    [Header("Player Debug")]
    public bool isGrounded = true;

    public bool onStation = false;
    public bool isCharging = false;
    private bool isDashing = false;
    public bool isRespawning = false;
    public bool isJumping = false;
    public float movementUpDown;
    public float movementLeftRight;
    public Vector2 movement;
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
        Physics2D.queriesStartInColliders = false;
        Physics2D.gravity = new Vector2(0, -35);
        
        inputManager = FindAnyObjectByType<InputManager>();
        selfCollider = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        blackScreen = GameObject.FindGameObjectWithTag("BlackScreen").GetComponent<Image>();
        
        playerBoost = GetComponent<PlayerBoost>();
        playerSound = FindObjectOfType<PlayerSound>();
        playerBoost.boostState = BoostStates.Gear2;
        activePreset = playerBoost.ReturnGearSpeed();
        
        timerController = GetComponent<PlayerTimer>();
        timerController.tMult = activePreset.timerMult;
        
        StartPos = transform.position; //sauvegarde position de départ
        line = GetComponent<LineRenderer>();
        blackScreenColor = Color.black;

        StartCoroutine(StartGame());
    }

    public void MakeJump()
    {
        if (isGrounded)
        {
            isJumping = true;
            rb.linearVelocity = new Vector2(rb.linearVelocity.x, activePreset.jumpForce);
            isGrounded = false;
        }
    }
    
    private IEnumerator DashLine()
    {
        yield return new WaitForSecondsRealtime(0.2f);
        line.enabled = false;
    }
    public void ChangeGear()
    {
        // Debug.Log("Gear Changed");
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
    }
    
    private void Update()
    {
        if (!isPushedBack && !isRespawning)
        {
            movementLeftRight = playerControls.Player.Direction.ReadValue<Vector2>().x;
            movementUpDown = playerControls.Player.Direction.ReadValue<Vector2>().y;
        }

        if ((Mathf.Abs(movementLeftRight) >= 0.1f) /*|| (Mathf.Abs(movementUpDown) >= 0.1f)*/)
            movement = new Vector2(movementLeftRight * effectiveSpeed, rb.linearVelocityY);
        else movement = Vector2.zero;

        if (timerController.t <= 0 && !isRespawning) StartCoroutine(MakeRespawn());
        
        if (coyotE >= 0f && !isGrounded)
        {
            coyotE -= Time.deltaTime;
        }
        
        if (playerControls.DEBUG.AdminGear.WasPressedThisFrame())
        {
            playerBoost.boostState = BoostStates.DEBUG;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
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
            // Debug.Log(rb.linearVelocity);
        }
    }
    
    public void Pushback(Vector2 hitPosition)
    {
        Vector2 dir = ((Vector2)transform.position - hitPosition).normalized;
        
        float x = Mathf.Sign(dir.x) * pushbackForceX;
        float y = pushbackForceY;

        pushbackVelocity = new Vector2(x, y);
        isPushedBack = true;
        pushbackTimer = pushbackDuration;
        isJumping = false;
        t = 0f;
        rb.linearVelocity = pushbackVelocity;
    }
    
    public IEnumerator StartGame()
    {
        while (blackScreenColor.a > 0f)
        {
            blackScreenColor.a -= Time.deltaTime;
            blackScreen.color = blackScreenColor;
            yield return null;
        }
        Respawn();
        // CanMove = true;
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
    
    public void Respawn()
    {
        // playerSound.StartSound();    Nullreference, empêche la fonction de continer, fix avec Fmod
        
        // Return
        timerController.t = timerController.timer;
        
        // Reset
        playerBoost.boostState = BoostStates.Gear2;
        activePreset = playerBoost.ReturnGearSpeed();
        inputManager.ActivateStation.Invoke();
        timerController.tMult = activePreset.timerMult;
        isRespawning = false;
        CanMove = true;
    }
    
    public void CrushRespawn()
    {
        rb.simulated = false;
        transform.position = tempRespawn.position;
        transform.SetParent(null);
        rb.simulated = true;
    }
    
    
    
    
    public void ExitStation()
    {
        onStation =  false;
        isCharging = false;
    }
    
    public void GroundPlayer()
    {
        isGrounded = true;
        coyotE = coyotETimer;
        isJumping = false;
        effectiveSpeed = activePreset.groundSpeed;
    }
    
    public void UngroundPlayer()
    {
        isGrounded = false;
        coyotE = 0f;
    }
    
    public void MakeDash()
    {
        Vector3[] posArray = new Vector3[2];
        Vector2 endPos = playerControls.Player.Direction.ReadValue<Vector2>().normalized;
        Vector2 test = new Vector2(transform.position.x, transform.position.y + 0.3f);
        RaycastHit2D checkDash = Physics2D.CircleCast(test, 0.1f, endPos, activePreset.airSpeed);
        
        posArray[0] = test;
            
        if (checkDash)
            endPos = checkDash.point;
        else
        {
            endPos *= activePreset.airSpeed;
            endPos += rb.position;
        }
        
        Debug.DrawLine(test, endPos, Color.green);
        
        posArray[1] = endPos;
        line.SetPositions(posArray);
        line.enabled = true;
        
        rb.position = endPos;
        if (!timerController.isCharging)
            timerController.t -= dashCost;
        StartCoroutine(DashLine());
    }
}