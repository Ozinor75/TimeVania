using UnityEngine;

public class PatrolActivationTrigger : MonoBehaviour
{
    public PatrolMovement movable;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if(other.CompareTag("Player"))
            movable.canMove = true;
    }
}
