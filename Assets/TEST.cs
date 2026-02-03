using System;
using UnityEngine;

public class TEST : MonoBehaviour
{
    public float speed;
    public float jumpForce;
    public float gravity = -9.81f;

    public bool isGrounded = true;
    private Rigidbody2D rb;
    private float dirInput;
    private Vector2 movement;

    void Start()
    {
        Physics2D.queriesStartInColliders = false;
        Physics2D.gravity = new Vector2(0, -gravity);
        rb = GetComponent<Rigidbody2D>();
    }

    private void IsGrounded()
    {
        RaycastHit2D hit = Physics2D.Raycast(transform.position, Vector2.down, 1.1f);
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
        IsGrounded();
        if (Input.GetKeyDown(KeyCode.Space) && isGrounded)
        {
            Debug.Log("JUMP !");
            rb.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
        }
    }

    void FixedUpdate()
    {
        if (isGrounded)
            rb.linearVelocityX = Input.GetAxis("Horizontal") * speed;
    }
}