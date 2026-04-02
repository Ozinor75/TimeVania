using UnityEngine;

public class MissileRider : MonoBehaviour
{
    private bool estAccroche = false;
    private Rigidbody2D rb;
    private float graviteInitiale; 

    private Transform missileActuel;
    private Vector3 decalageLocal; 

    private CustomInputs playerControls;
    
    private float cooldownAccrochage = 0f;

    private void Awake()
    {
        playerControls = new CustomInputs();
    }
    private void OnEnable()
    {
        playerControls.Enable();
    }
    private void OnDisable()
    {
        playerControls.Disable();
    }
    private void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        if (rb != null) graviteInitiale = rb.gravityScale; 
    }
    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.collider.isTrigger) return;
        if (!estAccroche && cooldownAccrochage <= 0f && collision.gameObject.name == "Corps")
        {
            missileActuel = collision.transform.root;

            if (collision.contacts[0].normal.y > -0.5f) 
            {
                decalageLocal = missileActuel.InverseTransformPoint(transform.position);
                estAccroche = true;
            
                if (rb != null)
                {
                    rb.gravityScale = 0f;
                    rb.linearVelocity = Vector2.zero;
                }
            }
        }
    }
    private void Update()
    {
        if (cooldownAccrochage > 0f)
        {
            cooldownAccrochage -= Time.deltaTime;
        }
        if (estAccroche)
        {
            if (missileActuel == null) 
            {
                SeDecrocher();
                return;
            }
            if (playerControls.Player.Jump.WasPressedThisFrame())
            {
                SeDecrocher();
            }
        }
    }
    private void FixedUpdate()
    {
        if (estAccroche && missileActuel != null)
        {
            Vector3 positionCible = missileActuel.TransformPoint(decalageLocal);
            rb.MovePosition(positionCible);
            rb.MoveRotation(missileActuel.rotation);
        }
    }
    private void SeDecrocher()
    {
        estAccroche = false;
        missileActuel = null;
        transform.rotation = Quaternion.identity; 
        if (rb != null)
        {
            rb.gravityScale = graviteInitiale; 
        }
        cooldownAccrochage = 0.2f; 
    }
}