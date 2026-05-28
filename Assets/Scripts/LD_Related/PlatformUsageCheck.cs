using UnityEngine;

public class PlatformUsageCheck : MonoBehaviour
{
    private MovingAndDestroy movingAndDestroy;
    
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
            movingAndDestroy.isOnPlatform = true;
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
            movingAndDestroy.isOnPlatform = false;
    }
    void Start()
    {
        movingAndDestroy = GetComponentInParent<MovingAndDestroy>();
    }

    void Update()
    {
        
    }
}
