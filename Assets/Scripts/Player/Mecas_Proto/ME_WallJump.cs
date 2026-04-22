using UnityEngine;

public class ME_WallJump : MonoBehaviour
{
    public PlayerController controls;
    public bool isWallSliding;
    public int lookSide;
    
    void Update()
    {
        if (!controls.isGrounded)
        {
            RaycastHit2D hitRight = Physics2D.Raycast(controls.rb.position, transform.right, 1f);
            RaycastHit2D hitLeft = Physics2D.Raycast(controls.rb.position, -transform.right, 1f);
            if (hitRight && hitRight.collider.gameObject.CompareTag("Ground"))
            {
                isWallSliding = true;
                controls.CanMove = false;
                lookSide = -1;
                Debug.Log("Right Slide");
            }

            else if (hitLeft && hitLeft.collider.gameObject.CompareTag("Ground"))
            {
                isWallSliding = true;
                controls.CanMove = false;
                lookSide = 1;
                Debug.Log("Left Slide");
            }
            
            else
            {
                isWallSliding = false;
                lookSide = 0;
            }
        }

        else
        {
            isWallSliding = false;
            lookSide = 0;
            controls.CanMove = true;
        }
    }
    
    public void WallJump()
    {
        if (isWallSliding)
        {
            controls.isJumping = true;
            controls.rb.linearVelocity = new Vector2(controls.activePreset.jumpForce / 2 * Mathf.Sign(lookSide), controls.activePreset.jumpForce / 2);
            isWallSliding = false;
            Debug.Log("Wall Jump !");
        }
    }
}
