using UnityEngine;

public class IsMovingPlatform : MonoBehaviour
{
    private BoxCollider2D selfCollider;
    private PlayerController playerController;
    
    void Start()
    {
        selfCollider = GetComponent<BoxCollider2D>();
        playerController = GetComponent<PlayerController>();
    }
    
    void Update()
    {
        IsMoving();
    }
    private void IsMoving()
    {
        RaycastHit2D hit = Physics2D.BoxCast(transform.position, selfCollider.size, 0f, Vector2.down, 0.5f);
        if (hit && hit.collider.CompareTag("Moving") && !playerController.isRespawning)
        {
            transform.SetParent(hit.transform); // Le joueur devient enfant de la plateforme
        }
    }
}
