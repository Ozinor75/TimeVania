using System;
using System.Globalization;
using UnityEngine;
using UnityEngine.Rendering;

public class ColliderController : MonoBehaviour
{
    public float platformCoyote;

    [Header("Damage Values")]
    public int spikeDamage;
    public int twompDamage;
    public int enemy1Damage;
    
    [Header("Debug")]
    public CapsuleCollider2D collider;
    public RaycastHit2D groundHit;
    public RaycastHit2D rightSlideHit;
    public RaycastHit2D leftSlideHit;
    public bool isOnPlatform;
    public float t;
    
    private PlayerController playerController;
    private PlayerFeedback playerFeedback;
    private PlayerSound playerSound;
    private PlayerTimer playerTimer;
    private MovingAndDestroy movingAndDestroy;
    
    void Start()
    {
        Physics2D.queriesStartInColliders = false;
        collider = GetComponent<CapsuleCollider2D>();
        playerController = GetComponent<PlayerController>();
        playerFeedback = GetComponent<PlayerFeedback>();
        playerTimer = GetComponent<PlayerTimer>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        
        playerController.wallJumpDir = 0;
        t = 0;
    }

    private void FixedUpdate()
    {
        if (!playerController.lockGroundCheck)
        {
            CheckGrounded();
            // if (playerController.WallJumpCapacity)
            //     CheckSliding();
        }
    }

    private void OnCollisionEnter2D(Collision2D other)      // ICI RAYCAST
    {
        if (playerController.isTouchable)
        {
            switch (other.gameObject.tag)
            {
                case "Spike":
                {
                    playerFeedback.InvokeEvent(playerFeedback.takeDamage);
                    playerTimer.ChangeTime(spikeDamage, false);
                    playerController.Pushback(other.transform.position);
                    playerController.MakeIFrame();
                    break;
                }
                
                case "Twomp":
                {
                    playerFeedback.InvokeEvent(playerFeedback.takeDamage);
                    playerTimer.ChangeTime(twompDamage, false);
                    playerController.Pushback(other.transform.position);
                    playerController.MakeIFrame();
                    break;
                }

                case "Enemy1":
                {
                    playerFeedback.InvokeEvent(playerFeedback.takeDamage);
                    playerTimer.ChangeTime(enemy1Damage, false);
                    playerController.Pushback(other.transform.position);
                    playerController.MakeIFrame();
                    break;
                }
            }
        }
    }
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Checkpoint"))
        {
            playerController.tempRespawn = other.transform.GetChild(0);
            playerController.tempRespawn.position = playerController.transform.position;
        }
    }
    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Checkpoint"))
            playerController.tempRespawn = playerController.respawnPoint;
        
    }

    // public void CheckSliding()
    // {
    //     rightSlideHit = Physics2D.CapsuleCast(playerController.rb.position, collider.size * 0.9f, CapsuleDirection2D.Vertical, 0f, Vector2.right, 0.2f);
    //     leftSlideHit = Physics2D.CapsuleCast(playerController.rb.position, collider.size * 0.9f, CapsuleDirection2D.Vertical, 0f, -Vector2.right, 0.2f);
    //
    //     if (!playerController.isGrounded)
    //     {
    //         if (rightSlideHit && rightSlideHit.collider.CompareTag("Ground"))
    //         { 
    //             playerController.isWallSliding = true;
    //             playerController.canDoubleJump = false;
    //             playerController.wallJumpDir = -1;
    //             playerController.CanMove = false;
    //             // Debug.Log("Wall at Right");
    //         }
    //
    //         else if (leftSlideHit && leftSlideHit.collider.CompareTag("Ground"))
    //         {
    //             playerController.isWallSliding = true;
    //             playerController.canDoubleJump = false;
    //             playerController.wallJumpDir = 1;
    //             playerController.CanMove = false;
    //             // Debug.Log("Wall at Left");
    //         }
    //
    //         else
    //         {
    //             playerController.isWallSliding = false;
    //             playerController.CanMove = true;
    //         }
    //     }
    //     
    //     else
    //     {
    //         playerController.isWallSliding = false;
    //         playerController.CanMove = true;
    //     }
    // }
    
    public void CheckGrounded()
    {
        groundHit = Physics2D.CapsuleCast(playerController.rb.position, collider.size * 0.9f, CapsuleDirection2D.Vertical, 0f, Vector2.down, 0.5f);
        // Debug.DrawLine(transform.position, groundHit.point, Color.red);

        if (groundHit)
        {
            if (groundHit.collider.CompareTag("Ground") || groundHit.collider.CompareTag("Wall"))
            {
                if (!playerController.isGrounded && !playerController.isJumping)
                {
                    playerController.GroundPlayer();
                    isOnPlatform = false;
                }// isjUmping modif
                if (isOnPlatform)
                {
                    ClearPlatformParent();
                }
            }
            
            else if ((groundHit.collider.CompareTag("Moving") || groundHit.collider.CompareTag("Missile") || groundHit.collider.CompareTag("TempMoving")) && !playerController.isRespawning)
            {
                if (!playerController.isGrounded)
                    playerController.GroundPlayer();
                if (!isOnPlatform)
                {
                    SetPlatformParent(groundHit.transform);
                    if (groundHit.collider.CompareTag("TempMoving"))
                    {
                        Debug.Log("ON PLATFORM TEST");
                        movingAndDestroy = groundHit.collider.transform.GetComponentInParent<MovingAndDestroy>();
                        movingAndDestroy.isOnPlatform = true;
                    }
                }
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
        // Debug.Log("SetPlatformParent");
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
