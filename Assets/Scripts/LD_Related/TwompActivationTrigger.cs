using UnityEngine;

public class TwompActivationTrigger : MonoBehaviour
{
    public Thwomp movable;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if(other.CompareTag("Player"))
            movable.canMove = true;
    }
}
