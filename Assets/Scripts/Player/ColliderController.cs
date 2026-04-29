using System;
using System.Globalization;
using UnityEngine;
using UnityEngine.Rendering;

public class ColliderController : MonoBehaviour
{
    public CapsuleCollider2D collider;
    public RaycastHit2D groundHit;
    public RaycastHit2D rightSlideHit;
    public RaycastHit2D leftSlideHit;
    public bool isOnPlatform;
    
    private PlayerController playerController;
    private PlayerSound playerSound;
    
    void Start()
    {
        Physics2D.queriesStartInColliders = false;
        collider = GetComponent<CapsuleCollider2D>();
        playerController = GetComponent<PlayerController>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        
        playerController.wallJumpDir = 0;
    }

    private void FixedUpdate()
    {
        CheckGrounded();
        if (playerController.WallJumpCapacity)
            CheckSliding();
    }

    private void OnCollisionEnter2D(Collision2D other)      // ICI RAYCAST
    {
        if (other.gameObject.CompareTag("Enemy"))
        {
            playerController.Pushback(other.transform.position);
            playerSound.HurtSound();
        }
    }
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Checkpoint"))
            playerController.tempRespawn = other.transform.GetChild(0);
    }
    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Checkpoint"))
            playerController.tempRespawn = playerController.respawnPoint;
        
    }

    public void CheckSliding()
    {
        rightSlideHit = Physics2D.CapsuleCast(playerController.rb.position, collider.size * 0.9f, CapsuleDirection2D.Vertical, 0f, Vector2.right, 0.5f);
        leftSlideHit = Physics2D.CapsuleCast(playerController.rb.position, collider.size * 0.9f, CapsuleDirection2D.Vertical, 0f, -Vector2.right, 0.5f);

        if (!playerController.isGrounded)
        {
            if (rightSlideHit && rightSlideHit.collider.CompareTag("Ground"))
            { 
                playerController.isWallSliding = true;
                playerController.canDoubleJump = false;
                playerController.CanMove = false;
                playerController.wallJumpDir = -1;

                Debug.Log("Wall at Right");
            }

            else if (leftSlideHit && leftSlideHit.collider.CompareTag("Ground"))
            {
                playerController.isWallSliding = true;
                playerController.canDoubleJump = false;
                playerController.CanMove = false;
                playerController.wallJumpDir = 1;
            
                Debug.Log("Wall at Left");
            }

            else
            {
                playerController.isWallSliding = false;
                // playerController.CanMove = true;
                Debug.Log("Falling");
            }
        }
        
        else
        {
            playerController.isWallSliding = false;
            playerController.CanMove = true;
        }
    }
    
    public void CheckGrounded()
    {
        groundHit = Physics2D.CapsuleCast(playerController.rb.position, collider.size * 0.9f, CapsuleDirection2D.Vertical, 0f, Vector2.down, 0.2f);
        // Debug.DrawLine(transform.position, groundHit.point, Color.red);

        if (groundHit)
        {
            if (groundHit.collider.CompareTag("Ground") || groundHit.collider.CompareTag("Wall"))
            {
                if (!playerController.isGrounded && !playerController.isJumping) // isjUmping modif
                    playerController.GroundPlayer();
                if (isOnPlatform)
                    ClearPlatformParent();
            }
            
            else if ((groundHit.collider.CompareTag("Moving") || groundHit.collider.CompareTag("Missile")) && !playerController.isRespawning)
            {
                if (!playerController.isGrounded)
                    playerController.GroundPlayer();
                if (!isOnPlatform)
                    SetPlatformParent(groundHit.transform);
            }
        }

        else
        {
            if (playerController.isGrounded)
                playerController.UngroundPlayer();
            if (isOnPlatform)
                ClearPlatformParent();
        }
    }

    public void SetPlatformParent(Transform parent)
    {
        transform.SetParent((parent));
        isOnPlatform = true;
    }

    public void ClearPlatformParent()
    {
        if (transform.parent != null)
        {
            transform.SetParent(null);
            isOnPlatform = false;
        }
    }
}
