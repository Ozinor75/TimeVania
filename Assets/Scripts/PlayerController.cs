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

    [Header("CoyotEtime")]
    public float coyotETimer;
    public float cototE;

    [Header("Player refs")]
    public CustomInputs playerControls;
    private Rigidbody2D rb;
    private BoxCollider2D selfCollider;
    private PlayerTimer timerController;
    private PlayerBoost playerBoost;
    public PlayerPresets activePreset;
    public GlobalTime globalTime;
    
    [Header("Player Debug")]
    public bool isGrounded = true;
    private bool isDashing = false;
    private float movementUpDown;
    private float movementLeftRight;
    private Vector2 movement;
    private Vector2 StartPos; //pos de départ pour restart
    
    

    [Header("Prefabs")] 
    public GameObject bubbleSlow;
    public GameObject bubbleFast;
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
        playerBoost.boostState = BoostStates.Gear2;
        activePreset = playerBoost.ReturnGearSpeed();
        
        timerController = GetComponent<PlayerTimer>();
        timerController.tMult = activePreset.timerMult;
        
        Physics2D.queriesStartInColliders = false;
        Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
        
        StartPos = rb.position;//sauvegarde position de départ
        Debug.Log(StartPos);
    }
    
    private void Update()
    {
        IsGrounded();
        movementLeftRight = playerControls.Player.Direction.ReadValue<Vector2>().x;
        movementUpDown = playerControls.Player.Direction.ReadValue<Vector2>().y;
        
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
                rb.AddForceY(activePreset.jumpForce, ForceMode2D.Impulse);
            }
        }
        
        // CONTROL INPUTS
<<<<<<< HEAD
<<<<<<< Updated upstream
        if (playerControls.Player.Upgrade.WasPressedThisFrame() && (playerBoost.boostState < BoostStates.Gear3))
=======
        if (playerControls.Player.Upgrade.WasPressedThisFrame() && activePreset == PlayerPresets.Mid)
>>>>>>> Stashed changes
=======
        if (playerControls.Player.Upgrade.WasPressedThisFrame())
>>>>>>> parent of 2301333 (LD - Angles)
        {
            globalTime.worldTime++;
            // playerBoost.boostState ++;
            playerBoost.boostState ++;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
            GameObject Bubble = Instantiate(bubbleSlow, transform.position, Quaternion.identity);
            Bubble.transform.parent = transform;
        }
        
        if (playerControls.Player.Downgrade.WasPressedThisFrame() && (playerBoost.boostState > BoostStates.Gear1))
        if (playerControls.Player.Upgrade.WasReleasedThisFrame())
        {
<<<<<<< Updated upstream
            globalTime.worldTime--;
            // playerBoost.boostState --;
            playerBoost.boostState--;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
<<<<<<< HEAD
=======
            globalTime.worldTime = WorldTime.TWO;
            playerBoost.boostState = BoostStates.Gear2;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
            Destroy(FindAnyObjectByType<TimeBubble>().gameObject);
        }
        
        if (playerControls.Player.Downgrade.WasPressedThisFrame() && activePreset == PlayerPresets.Mid)
=======
            Destroy(FindAnyObjectByType<TimeBubble>().gameObject);
        }
        
        if (playerControls.Player.Downgrade.WasPressedThisFrame())
>>>>>>> parent of 2301333 (LD - Angles)
        {
            globalTime.worldTime--;
            playerBoost.boostState --;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
            GameObject Bubble = Instantiate(bubbleFast, transform.position, Quaternion.identity);
            Bubble.transform.parent = transform;
        }
        
        if (playerControls.Player.Downgrade.WasReleasedThisFrame())
        {
<<<<<<< HEAD
            globalTime.worldTime = WorldTime.TWO;
            playerBoost.boostState = BoostStates.Gear2;
=======
            globalTime.worldTime++;
            playerBoost.boostState++;
>>>>>>> parent of 2301333 (LD - Angles)
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
            Destroy(FindAnyObjectByType<TimeBubble>().gameObject);
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> parent of 2301333 (LD - Angles)
        }
        
        if (playerControls.Player.Dash.WasPressedThisFrame() && timerController.t > dashCost)
        {
            Vector2 test = rb.linearVelocity.normalized;
            RaycastHit2D checkDash = Physics2D.BoxCast(transform.position, selfCollider.size, 0f, test, activePreset.airSpeed);
            // RaycastHit2D checkDash = Physics2D.Raycast(transform.position, test, activePreset.airSpeed);
            Debug.Log(checkDash.point);
            if (checkDash)
            {
                test = checkDash.point;
            }
            else
            {
                test *= activePreset.airSpeed;
                test += rb.position;
            }
            
            rb.position = test;
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
        rb.linearVelocity = movement;
    }

    // INFORMATION TAKING
    private void IsGrounded()
    {
        RaycastHit2D hit = Physics2D.BoxCast(transform.position, selfCollider.size, 0f, Vector2.down, 0.1f);
                                                                                                                                            
        Debug.DrawLine(transform.position, hit.point, Color.red);
        if (hit && hit.collider.CompareTag("Ground"))
        {
            cototE = coyotETimer;
            isGrounded = true;
            effectiveSpeed = activePreset.groundSpeed;
        }
        
        else
        {
            cototE -= Time.deltaTime;
            isGrounded = false;
            effectiveSpeed = activePreset.airSpeed;
        }
    }
    
    void Respawn()
    {
        Debug.Log("OUTTA TIME !!!");
        // Return
        rb.position = StartPos;
        timerController.t = timerController.timer;
        // Reset
        playerBoost.boostState = BoostStates.Gear2;
        activePreset = playerBoost.ReturnGearSpeed();
        timerController.tMult = activePreset.timerMult;
        Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
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