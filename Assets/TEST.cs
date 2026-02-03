using System;
using UnityEngine;

public class TEST : MonoBehaviour
{
    public float speed;
    public float jumpForce;
    
    private Rigidbody2D rb;
    private float dirInput;
    private Vector2 movement;
    
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log("JUMP !");
            rb.AddForce(Vector2.up * jumpForce);
        }
    }

    void FixedUpdate()
    {
        rb.linearVelocityX = Input.GetAxis("Horizontal") * speed;
    }
}
