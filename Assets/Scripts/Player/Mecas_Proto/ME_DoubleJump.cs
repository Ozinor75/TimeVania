using System;
using UnityEngine;
using UnityEngine.Serialization;

public class ME_DoubleJump : MonoBehaviour
{
    public PlayerController controls;
    public ME_WallJump wallJump;
    public bool canDoubleJump = true;

    private void Update()
    {
        if (controls.isGrounded)
        {
            canDoubleJump = true;
        }
    }

    public void ChooseIfDoubleJump()
    {
        Debug.Log("Choosing");
        // if (/*!hasDJumped &&*/ !canDoubleJump)
            // CopyJump();     // Quand intégré : Choix entre saut et Saut en l'air, pas Copy et Saut en L'air
        // else if (canDoubleJump /*&& !hasDJumped*/)
        DoulbeJump();
    }
    
    public void CopyJump()
    {
        canDoubleJump = true;
        Debug.Log("Jump !");
    }

    public void DoulbeJump()
    {
        if (canDoubleJump && !controls.isGrounded) 
        {
            if (wallJump)
            {
                if (!wallJump.isWallSliding)
                {
                    controls.isJumping = true;
                    controls.rb.linearVelocity = new Vector2(controls.rb.linearVelocity.x, controls.activePreset.jumpForce);
                    controls.isGrounded = false;
                    canDoubleJump = false;
                    Debug.Log("Double Jump !");
                }
            }

            else
            {
                controls.isJumping = true;
                controls.rb.linearVelocity = new Vector2(controls.rb.linearVelocity.x, controls.activePreset.jumpForce);
                controls.isGrounded = false;
                canDoubleJump = false;
                Debug.Log("Double Jump !");
            }
        }
    }
}
