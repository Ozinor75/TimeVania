using System;
using System.Collections;
using NUnit.Framework.Internal;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.HID;

public class PlayerController : MonoBehaviour
{
    [Header("Player Stats")]
    public float effectiveSpeed;
    public float dashCost;
    public float GravityNotJumping; // gravity qui maintient le joueur au sol
    
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
    public CustomInputs playerControls;
    public Rigidbody2D rb;
    private BoxCollider2D selfCollider;
    private PlayerTimer timerController;
    private PlayerBoost playerBoost;
    private PlayerSound playerSound;
    public PlayerPresets activePreset;
    public GlobalTime globalTime;
    private LineRenderer line;
    
    [Header("Player Debug")]
    public bool isGrounded = true;
    private bool isDashing = false;
    private bool notJumping = true; //check si on doit détecter le sol ou pas
    private float movementUpDown;
    private float movementLeftRight;
    private Vector2 movement;
    private Vector2 StartPos; //pos de départ pour restart

    [Header("Prefabs")] 
    public GameObject bubbleSlow;
    public GameObject bubbleFast;

    private float t = 0f;//timer pour isgrounded
    private float GlisseDuree = 0.1f; // Durée pour glisser
    private float GlisseTimer = 0f; // timer pour réactiver la gravité des boosts en l'air
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
        selfCollider = GetComponent<BoxCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        
        playerBoost = GetComponent<PlayerBoost>();
        playerSound = FindObjectOfType<PlayerSound>();
        playerBoost.boostState = BoostStates.Gear2;
        activePreset = playerBoost.ReturnGearSpeed();
        
        timerController = GetComponent<PlayerTimer>();
        timerController.tMult = activePreset.timerMult;
        
        Physics2D.queriesStartInColliders = false;
        Physics2D.gravity = new Vector2(0, -activePreset.slideSpeed);
        
        StartPos = rb.position;     //sauvegarde position de départ
        line = GetComponent<LineRenderer>();
    }
    
    private void Update()
    {
        if (!isPushedBack)
        {
            movementLeftRight = playerControls.Player.Direction.ReadValue<Vector2>().x;
            movementUpDown = playerControls.Player.Direction.ReadValue<Vector2>().y;
        }

        if (timerController.t <= 0) Respawn();
        
        if (cototE >= 0f)
        {
            cototE -= Time.deltaTime;
        }
        
        movement = new Vector2(movementLeftRight * effectiveSpeed, rb.linearVelocityY);
        
        if (playerControls.Player.Jump.WasPressedThisFrame())
        {
            if (isGrounded || cototE > 0f)
            {
                playerSound.Jump();
                notJumping = false; //arrêter la détection du sol
                GlisseTimer = 0f;
                Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
                // Debug.Log("Jump " + Physics2D.gravity);
                rb.linearVelocity = new Vector2(rb.linearVelocity.x, activePreset.jumpForce);            }
        }
        
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
        
        // CONTROL INPUTS

        if (playerControls.Player.Upgrade.WasPressedThisFrame() && activePreset == PlayerPresets.Mid)
        {
            playerSound.Swift();
            globalTime.worldTime++;
            playerBoost.boostState ++;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
            // GameObject Bubble = Instantiate(bubbleSlow, transform.position, Quaternion.identity);
            // Bubble.transform.parent = transform;
        }
        
        if (playerControls.Player.Upgrade.WasReleasedThisFrame())
        {
            playerSound.Mid();
            globalTime.worldTime = WorldTime.TWO;
            playerBoost.boostState = BoostStates.Gear2;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
            // Destroy(FindAnyObjectByType<TimeBubble>().gameObject);
        }
        
        if (playerControls.Player.Downgrade.WasPressedThisFrame() && activePreset == PlayerPresets.Mid)
        {
            playerSound.Slow();
            globalTime.worldTime--;
            playerBoost.boostState --;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
            
            if (!isGrounded && rb.linearVelocityY < 0)
            {
                rb.linearVelocity = new Vector2(rb.linearVelocity.x, rb.linearVelocityY * 0.2f);
            }
            
            // GameObject Bubble = Instantiate(bubbleFast, transform.position, Quaternion.identity);
            // Bubble.transform.parent = transform;
        }

        if (playerControls.Player.Downgrade.WasReleasedThisFrame())
        {
            playerSound.Mid();
            globalTime.worldTime = WorldTime.TWO;
            playerBoost.boostState = BoostStates.Gear2;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
            // Destroy(FindAnyObjectByType<TimeBubble>().gameObject);
        }
        
        if (playerControls.Player.Dash.WasPressedThisFrame() && timerController.t > dashCost)
        {
            Vector3[] posArray = new Vector3[2];
            Vector2 endPos = rb.linearVelocity.normalized;
            RaycastHit2D checkDash = Physics2D.BoxCast(transform.position, selfCollider.size, 0f, endPos, activePreset.airSpeed);
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
            playerSound.Dash();
            rb.position = endPos;
            timerController.t -= dashCost;
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
        rb.linearVelocity = new Vector2(movementLeftRight * effectiveSpeed, rb.linearVelocityY);
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
        playerSound.StopSound();
        Debug.Log("OUTTA TIME !!!");
        // Return
        rb.position = StartPos;
        timerController.t = timerController.timer;
        // Reset
        playerBoost.boostState = BoostStates.Gear2;
        activePreset = playerBoost.ReturnGearSpeed();
        timerController.tMult = activePreset.timerMult;
        Physics2D.gravity = new Vector2(0, -activePreset.slideSpeed); //forcer une gravité pour maintenir le player au sol
        // Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
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