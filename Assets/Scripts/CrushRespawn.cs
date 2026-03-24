using UnityEngine;


[RequireComponent(typeof(BoxCollider2D))]
[RequireComponent(typeof(Rigidbody2D))]
public class CrushRespawn : MonoBehaviour
{
[Header("Paramètres d'Écrasement")]
    public float crushTolerance = 0.05f;
    
    [Header("Système de Respawn")]
    public Vector3 currentRespawnPosition;

    private BoxCollider2D col;
    private Rigidbody2D rb;
    private PlayerController playerController;

    void Start()
    {
        col = GetComponent<BoxCollider2D>();
        rb = GetComponent<Rigidbody2D>();
        playerController = GetComponent<PlayerController>();
        currentRespawnPosition = transform.position;
    }

    void Update()
    {
        CheckCrush();
    }

    private void CheckCrush()
    {
        float distanceX = col.bounds.extents.x + crushTolerance;
        float distanceY = col.bounds.extents.y + crushTolerance;
        
        RaycastHit2D hitLeft = Physics2D.Raycast(transform.position, Vector2.left, distanceX);
        RaycastHit2D hitRight = Physics2D.Raycast(transform.position, Vector2.right, distanceX);
        if (hitLeft.collider != null && hitRight.collider != null)
        {
            if (hitLeft.collider.CompareTag("Wall") || hitRight.collider.CompareTag("Wall"))
            {
                Debug.Log("Écrasement Horizontal !");
                ExecuterRespawn();
                return;
            }
        }

        RaycastHit2D hitUp = Physics2D.Raycast(transform.position, Vector2.up, distanceY);
        RaycastHit2D hitDown = Physics2D.Raycast(transform.position, Vector2.down, distanceY);
        if (hitUp.collider != null && hitDown.collider != null)
        {
            if (hitUp.collider.CompareTag("Wall") || hitDown.collider.CompareTag("Wall"))
            {
                Debug.Log("Écrasement Vertical !");
                ExecuterRespawn();
            }
        }
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Checkpoint"))
        {
            Transform specificSpawn = other.transform.Find("SpawnPoint");
            if (specificSpawn != null)
            {
                currentRespawnPosition = specificSpawn.position;
            }
        }
    }

    public void ExecuterRespawn()
    {
        transform.position = currentRespawnPosition;
        rb.linearVelocity = Vector2.zero;
        transform.SetParent(null);
    }
}
