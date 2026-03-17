using UnityEngine;

public class Missile : MonoBehaviour
{
    public GlobalTime globalTime;
    public float timeScale;
    
    [Header("Paramètres du Projectile")]
    public float tempsDeVie; 

    [Header("Vitesses")]
    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;
    
    private bool destroying = false;
    private Vector3 directionDeTir;
    private float t;
    private PlayerController PlayerController;
    
    void Start()
    {
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
        directionDeTir = transform.right;
        t =tempsDeVie;
    }

    void FixedUpdate()
    {
        switch (globalTime.worldTime)
        {
            case WorldTime.ONE:
                timeScale = acceleratedTime;
                break;
            case WorldTime.TWO:
                timeScale = normalTime;
                break;
            case WorldTime.THREE:
                timeScale = slowedTime;
                break;
        }
        
        transform.position += directionDeTir * timeScale * Time.deltaTime;
        if (PlayerController != null && !PlayerController.CanMove)
        {
            PlayerController.platformVelocity = directionDeTir * timeScale;
        }
        
        if (destroying)
        {
            t -= Time.deltaTime*timeScale;
            // Debug.Log(t);
            if (t <= 0)
            {
                Destroy(gameObject);
            }
        }
    }
    private void OnCollisionEnter2D(Collision2D collision)
    {
        // Debug.Log(collision.gameObject.tag);
        if (collision.gameObject.CompareTag("Player"))
        {
            PlayerController = collision.gameObject.GetComponent<PlayerController>();
            PlayerController.CanMove =  false;
            PlayerController.platformVelocity = directionDeTir * timeScale;
        }
        destroying =  true;
    }
    
    private void OnCollisionStay2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Player") && PlayerController == null)
        {
            PlayerController = collision.gameObject.GetComponent<PlayerController>();
            PlayerController.CanMove = false;
        }
    }
    
    private void OnCollisionExit2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            PlayerController.CanMove = true;
            PlayerController.platformVelocity = Vector2.zero;
            PlayerController = null;
        }
    }
}
