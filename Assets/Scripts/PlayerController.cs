using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.HID;

public class PlayerController : MonoBehaviour
{
    [Header("Player Stats")]
    private float groundSpeed;
    private float airSpeed;
    private float jumpForce;
    private float gravity;
    private float effectiveSpeed;
    public float upGravityFactor;
    public float downGravityFactor;

    [Header("Player refs")]
    public CustomInputs playerControls;
    private Rigidbody2D rb;
    private CapsuleCollider2D selfCollider;
    private PlayerTimer timerController;
    private PlayerBoost playerBoost;
    public PlayerPresets activePreset;
    
    [Header("Player Debug")]
    public bool isGrounded = true;
    public bool isDashing = false;
    private float movementUpDown;
    private float movementLeftRight;
    private Vector2 movement;
    public float vMax;
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
        selfCollider = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        
        playerBoost = GetComponent<PlayerBoost>();
        playerBoost.boostState = BoostStates.BaseMode;
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
        
        // CONTROL INPUTS
        if (playerControls.Player.Upgrade.WasPressedThisFrame() && (playerBoost.boostState < BoostStates.SuperBoost))
        {
            playerBoost.boostState ++;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
        }
        
        if (playerControls.Player.Downgrade.WasPressedThisFrame() && (playerBoost.boostState > BoostStates.LowEnergy))
        {
            playerBoost.boostState --;
            activePreset = playerBoost.ReturnGearSpeed();
            timerController.tMult = activePreset.timerMult;
            Physics2D.gravity = new Vector2(0, -activePreset.gravityForce);
        }
        
        if (playerControls.Player.Jump.WasPressedThisFrame() && isGrounded)
        {
            rb.AddForce(Vector2.up * activePreset.jumpForce, ForceMode2D.Impulse);
        }
        
        if (playerControls.Player.Dash.WasPressedThisFrame() && !isDashing)
        {
            StartCoroutine(Dash());
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
        rb.linearVelocityX = movementLeftRight * effectiveSpeed;

        if (!isGrounded && (movementUpDown < -0.2f || movementUpDown > 0.2f))
        {
            if (movementUpDown < 0f)
            {
                effectiveSpeed = 0f;
                rb.gravityScale = downGravityFactor;
            }
                
            if (movementUpDown > 0f && rb.linearVelocityY <= 0f)
            {
                effectiveSpeed = activePreset.airSpeed;
                rb.gravityScale = upGravityFactor;
            }
        }
        else
        {
            effectiveSpeed = activePreset.airSpeed;
            rb.gravityScale = 1f;
        }
    }

    // INFORMATION TAKING
    private void IsGrounded()
    {
        RaycastHit2D hit = Physics2D.CapsuleCast(transform.position, selfCollider.size, CapsuleDirection2D.Vertical, 0f, Vector2.down, 0.1f);
                                                                                                                                            
        Debug.DrawLine(transform.position, hit.point, Color.red);
        if (hit && hit.collider.CompareTag("Ground"))
        {
            isGrounded = true;
            effectiveSpeed = activePreset.groundSpeed;

        }
        
        else if (isDashing)
            effectiveSpeed = activePreset.dashSpeed;
        
        else
        {
            isGrounded = false;
            if (movementUpDown > -0.2f && movementUpDown < 0.2f)
                effectiveSpeed = activePreset.airSpeed;
        }
    }
    
    // MECHANICS
    private IEnumerator Dash()
    {
        isDashing = true;
        var originalGravity = rb.gravityScale;
        rb.gravityScale = 0;
        rb.linearVelocity = Vector2.zero;
        rb.linearVelocityX = movementLeftRight * activePreset.dashSpeed;
        yield return new WaitForSecondsRealtime(activePreset.dashDuration);
        rb.gravityScale = originalGravity;
        isDashing = false;
    }
}