using System;
using UnityEngine;
using UnityEngine.Rendering;

public class ColliderController : MonoBehaviour
{
    public CapsuleCollider2D collider;
    public RaycastHit2D groundHit;
    public RaycastHit2D dashHit;
    public bool isOnPlatform;
    
    private PlayerController playerController;
    private PlayerSound playerSound;
    
    void Start()
    {
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

    public void CheckGrounded()
    {
        groundHit = Physics2D.CapsuleCast(transform.position, collider.size * 0.9f, CapsuleDirection2D.Vertical, 0f, Vector2.down, 0.2f);
        Debug.DrawLine(transform.position, groundHit.point, Color.red);
        Debug.Log(Physics2D.gravity);

        if (groundHit)
        {
            if (groundHit.collider.CompareTag("Ground") || groundHit.collider.CompareTag("Wall") )
            {
                playerController.GroundPlayer();
                if (isOnPlatform)
                    ClearPlatformParent();
            }
            
            else if (groundHit.collider.CompareTag("Moving") || groundHit.collider.CompareTag("Missile") && !playerController.isRespawning)
            {
                playerController.GroundPlayer();
                if (!isOnPlatform)
                    SetPlatformParent(groundHit.transform);
            }
        }

        else
        {
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
        transform.SetParent((null));
        isOnPlatform = false;
    }
}
