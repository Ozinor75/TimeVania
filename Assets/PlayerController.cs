using System;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.HID;

public class PlayerController : MonoBehaviour
{
    public float groundSpeed;
    public float airSpeed;
    public float jumpForce;
    public float gravity;
    public CustomInputs playerControls;
    
    public bool isGrounded = true;
    private Rigidbody2D rb;
    private CapsuleCollider2D selfCollider;
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
        selfCollider = GetComponent<CapsuleCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        
        Physics2D.queriesStartInColliders = false;
        Physics2D.gravity = new Vector2(0, -gravity);
    }

    private void IsGrounded()
    {
        // RaycastHit2D hit = Physics2D.Raycast(transform.position, Vector2.down, 1.1f);    // Simple Ray
        RaycastHit2D hit = Physics2D.CircleCast(transform.position, selfCollider.size.x,Vector2.down, selfCollider.size.y/2 + 0.1f);        // J'ai mis un circle, comme ça c'est plus accurate à la forme
                                                                                                                                                                        // + Le radius correspondant au collider pour pas avoir à le changer
        Debug.DrawLine(transform.position, hit.point, Color.red);
        if (hit && hit.collider.CompareTag("Ground"))
        {
            isGrounded = true;
            Debug.DrawLine(transform.position, hit.point, Color.red);
        }
        else
            isGrounded = false;
    }

    private void Update()
    {
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
        // if (isGrounded)
            // rb.linearVelocityX = movementLeftRight * groundSpeed;
        // else
            // rb.linearVelocityX = movementLeftRight * airSpeed;

        rb.linearVelocityX = isGrounded ? movementLeftRight * groundSpeed : movementLeftRight * airSpeed;   // Littéralement celle du dessus en une seule ligne
    }
}