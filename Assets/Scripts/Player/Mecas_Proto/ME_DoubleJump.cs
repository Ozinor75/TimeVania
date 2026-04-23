using System;
using UnityEngine;
using UnityEngine.Serialization;

public class ME_DoubleJump : MonoBehaviour
{
    public float DJumpCost;
    
    public PlayerController controls;
    public ME_WallJump wallJump;
    public bool canDoubleJump;
    public bool hasDoubleJumped;
    
    private void Update()
    {
        if (controls.isGrounded)
        {
            hasDoubleJumped = false;
            canDoubleJump = false; 
        }

        if (controls.rb.linearVelocityY < 0f && !controls.isGrounded)   // si tu tombes et pas grounded
            canDoubleJump = true;

        if (wallJump.isWallSliding)
            canDoubleJump = false;
    }

    public void ChooseIfDoubleJump()
    {
        Debug.Log("Choosing");
        if (!hasDoubleJumped && !canDoubleJump)    // ???
            CopyJump();     // Quand intégré : Choix entre saut et Saut en l'air, pas Copy et Saut en L'air
        else if (!hasDoubleJumped && canDoubleJump)
            DoulbeJump();
    }
    
    public void CopyJump()      // si tu sautes (disparait à l'intégration
    {
        Debug.Log("Jump !");
        canDoubleJump = true;
    }

    public void DoulbeJump()
    {
        if (canDoubleJump && !controls.isGrounded && !hasDoubleJumped) 
        {
            if (wallJump && !wallJump.isWallSliding)
            {
                controls.isJumping = true;
                controls.rb.linearVelocityY = controls.activePreset.jumpForce;
                controls.isGrounded = false;
                canDoubleJump = false;
                hasDoubleJumped = true;
                
                if (!controls.timerController.isCharging)
                    controls.timerController.t -= DJumpCost;
                Debug.Log("Double Jump SLIDED!");
            }

            else
            {
                controls.isJumping = true;
                controls.rb.linearVelocityY = controls.activePreset.jumpForce;
                controls.isGrounded = false;
                canDoubleJump = false;
                hasDoubleJumped = true;
                
                if (!controls.timerController.isCharging)
                    controls.timerController.t -= DJumpCost;
                Debug.Log("Double Jump !");
            }
        }
    }
}
