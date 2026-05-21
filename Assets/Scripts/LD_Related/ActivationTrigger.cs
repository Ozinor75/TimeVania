using System;
using UnityEngine;

public class ActivationTrigger : MonoBehaviour
{
    public PlatformMovement movable;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if(other.CompareTag("Player"))
            movable.canMove = true;
    }
}
