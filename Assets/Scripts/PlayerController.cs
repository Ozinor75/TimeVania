using System;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.HID;

public class PlayerController : MonoBehaviour
{
    [Header("Player Stats")]
    public float groundSpeed;
    
    public float airSpeed;
    
    public float jumpForce;
    
    public float gravity;
    
    private float effectiveSpeed;
    private float effectiveJumpForce;   // Unused, l'utiliser plus tard si nécéssaire

    [Header("Player refs")]
    public CustomInputs playerControls;
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
    }
    
    private void Update()
    {
        if (playerControls.DEBUG.TimerReset.WasPressedThisFrame())
            timerController.t = timerController.timer;
        
        movementLeftRight = playerControls.Player.Direction.ReadValue<float>();
        
        IsGrounded();
        
        if (playerControls.Player.Jump.WasPressedThisFrame() && isGrounded)
        {
            Debug.Log("JUMP !");
            rb.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
        }
    }

    void FixedUpdate()
    {
        rb.linearVelocityX = movementLeftRight * effectiveSpeed;
    }

    private void IsGrounded()
    {
        RaycastHit2D hit = Physics2D.CapsuleCast(transform.position, selfCollider.size, CapsuleDirection2D.Vertical, 0f, Vector2.down, 0.1f);
                                                                                                                                            
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
}