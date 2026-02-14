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
    
    [Header("Player Debug")]
    public bool isGrounded = true;
    private bool isDashing = false;
    private float movementUpDown;
    private float movementLeftRight;
    private Vector2 movement;
    
    
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
    }
    
    private void Update()
    {
        IsGrounded();
        movementLeftRight = playerControls.Player.Direction.ReadValue<Vector2>().x;
        movementUpDown = playerControls.Player.Direction.ReadValue<Vector2>().y;
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
        if (playerControls.Player.Upgrade.WasPressedThisFrame() && (playerBoost.boostState < BoostStates.Gear3))
        {
            playerBoost.boostState ++;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
        }
        
        if (playerControls.Player.Downgrade.WasPressedThisFrame() && (playerBoost.boostState > BoostStates.Gear1))
        {
            playerBoost.boostState --;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
        }
        
        if (playerControls.Player.Dash.WasPressedThisFrame() && !isDashing)
        {
            Vector2 test = rb.linearVelocity.normalized;
            test *= activePreset.airSpeed;
            rb.position = rb.position + test;
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