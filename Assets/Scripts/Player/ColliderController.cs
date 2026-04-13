using System;
using UnityEngine;
using UnityEngine.Rendering;

public class ColliderController : MonoBehaviour
{
    public CapsuleCollider2D collider;
    public RaycastHit2D groundHit;
    public bool isOnPlatform;
    
    private PlayerController playerController;
    private PlayerSound playerSound;
    
    void Start()
    {
        Physics2D.queriesStartInColliders = false;
        collider = GetComponent<CapsuleCollider2D>();
        playerController = GetComponent<PlayerController>();
        playerSound = FindFirstObjectByType<PlayerSound>();
    }

    private void FixedUpdate()
    {
        CheckGrounded();
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

    public void CheckGrounded()
    {
        groundHit = Physics2D.CapsuleCast(playerController.rb.position, collider.size * 0.9f, CapsuleDirection2D.Vertical, 0f, Vector2.down, 0.2f);
        Debug.DrawLine(transform.position, groundHit.point, Color.red);

        if (groundHit)
        {
            if (groundHit.collider.CompareTag("Ground") || groundHit.collider.CompareTag("Wall"))
            {
                if (!playerController.isGrounded)
                    playerController.GroundPlayer();
                if (isOnPlatform)
                    ClearPlatformParent();
            }
            
            else if (groundHit.collider.CompareTag("Moving") || groundHit.collider.CompareTag("Missile") && !playerController.isRespawning)
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
        transform.SetParent(null);
        isOnPlatform = false;
    }
}
