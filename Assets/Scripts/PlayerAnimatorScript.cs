using System;
using UnityEngine;

public class PlayerAnimatorScript : MonoBehaviour
{
    private Animator animator;

    private void Start()
    {
        animator = GetComponent<Animator>();
    }

    public void SetJumpStart()
    {
        animator.SetTrigger("Jump");
    }

    public void SetRunning()
    {
        animator.SetBool("isRunning", true);
    }
    
    public void SetNotRunning()
    {
        animator.SetBool("isRunning", false);
    }

    public void RotatePlayer(Vector2 direction)
    {
        
    }
}
