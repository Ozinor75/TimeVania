using System;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.HID;

public class PlayerController : MonoBehaviour
{
    [Header("Player Stats")]
    public float groundSpeed;
    public float groundSpeedBonus;
    private float groundSpeedBase;
    
    public float airSpeed;
    public float airSpeedBonus;
    private float airSpeedBase;
    
    public float jumpForce;
    public float jumpForceBonus;
    private float jumpForceBase;
    
    public float gravity;
    public float gravityBonus;
    private float gravityBase;
    
    private float effectiveSpeed;
    private float effectiveJumpForce;   // Unused, l'utiliser plus tard si nécéssaire
    
    [Header("Player Boosts")]
    public float speedBoostTimer;
    public float speedBoostT;
    public bool isSpeedBoosted;
    
    public float jumpBoostTimer;
    public float jumpBoostT;
    public bool isJumpBoosted;
    
    [Header("Player refs")]
    private CustomInputs playerControls;
    private Rigidbody2D rb;
    private CapsuleCollider2D selfCollider;
    private PlayerTimer timerController;
    
    [Header("Player Debug")]
    public bool isGrounded = true;
    private float dirInput;
    private float movementLeftRight;
    private Vector2 movement;

    private void OnEnable()
    {
        playerControls = new CustomInputs();
        playerControls.Enable();
    }
    private void OnDisable()
    {
        playerControls.Disable();
    }

    void Start()
    {
        timerController = GetComponent<PlayerTimer>();
        selfCollider = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        
        Physics2D.queriesStartInColliders = false;
        Physics2D.gravity = new Vector2(0, -gravity);
        
        groundSpeedBase = groundSpeed;
        airSpeedBase = airSpeed;
        jumpForceBase = jumpForce;
    }
    
    private void Update()
    {
        if (playerControls.DEBUG.TimerReset.WasPressedThisFrame())
            timerController.t = timerController.timer;
        
        movementLeftRight = playerControls.Player.Direction.ReadValue<float>();
        
        IsGrounded();
        BoostTimerEffect();
        
        if (playerControls.Player.Jump.WasPressedThisFrame() && isGrounded)
        {
            Debug.Log("JUMP !");
            rb.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
        }

        if (playerControls.Player.SpeedBoost.WasPressedThisFrame())
        {
            Debug.Log("SPEED BOOST !");             // ACCELERATE TIME
            timerController.t -= speedBoostTimer;   // remove time to timer
            speedBoostT = speedBoostTimer;          // reset boost timeer
            groundSpeed += groundSpeedBonus;                       // apply boost
            isSpeedBoosted = true;                  // apply boost bool
        }
        
        if (playerControls.Player.JumpBoost.WasPressedThisFrame())
        {
            Debug.Log("JUMP BOOST !");
            timerController.t -= jumpBoostTimer;
            jumpBoostT = jumpBoostTimer;
            jumpForce += jumpForceBonus;
            airSpeed += airSpeedBonus;
            isJumpBoosted = true;
        }
    }

    void FixedUpdate()
    {
        rb.linearVelocityX = movementLeftRight * effectiveSpeed;
    }

    private void IsGrounded()
    {
        RaycastHit2D hit = Physics2D.CapsuleCast(transform.position, selfCollider.size, CapsuleDirection2D.Vertical, 0f, Vector2.down, 0.1f);    // + Le radius correspondant au collider pour pas avoir à le changer
                                                                                                                                            
        Debug.DrawLine(transform.position, hit.point, Color.red);
        if (hit && hit.collider.CompareTag("Ground"))
        {
            isGrounded = true;
            effectiveSpeed = groundSpeed;
        }
        else
        {
            isGrounded = false;
            effectiveSpeed = airSpeed;
        }
    }

    void BoostTimerEffect()
    {
        if (isSpeedBoosted)
        {
            speedBoostT -= Time.deltaTime;
            if (speedBoostT <= 0f)
            {
                groundSpeed = groundSpeedBase;
                isSpeedBoosted = false;
            }
        }
        
        if (isJumpBoosted)
        {
            jumpBoostT -= Time.deltaTime;
            if (jumpBoostT <= 0f)
            {
                jumpForce = jumpForceBase;
                airSpeed = airSpeedBase;
                isJumpBoosted = false;
            }
        }
    }
}