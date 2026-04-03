using UnityEngine;
using System.Collections;

public class EnemyShooter : MonoBehaviour
{
    public GlobalTime globalTime;
    
    [Header("Targets")]
    public GameObject projectilePrefab;
    public Transform firePoint; 

    [Header("Firing Parameters")]
    public float cooldown = 3f;
    private float cooldownT = 0f;
    public float fireRate = 0.5f;
    private float fireRateT = 0f;
    public int shotCount = 3;
    private int shotCountC = 0;
    
    [Header("Rotation Speed")]
    public Transform player;
    public float rotationSpeed;
    private bool playerInZone = false;
    private bool isAttacking = false;

    void Start()
    {
        globalTime = FindFirstObjectByType<GlobalTime>();
    }
    
    void Update()
    {
        if (playerInZone && player != null)
        {
            FacePlayer();

            if (isAttacking)
            {
                cooldownT = 0f;
                fireRateT += Time.deltaTime * globalTime.active;
            }
            
            else cooldownT += Time.deltaTime * globalTime.active;
            
            if (fireRateT >= fireRate )
            {
                if (shotCountC < shotCount)
                {
                    Shoot();
                    shotCountC++;
                }

                else
                {
                    isAttacking = false;
                    shotCountC = 0;
                }
                
                fireRateT = 0f;
            }
            

            if (cooldownT >= cooldown)
                isAttacking = true;
        }
    }
    
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            if (player == null)
            {
                player = collision.transform;
            }

            cooldownT = 0f;
            fireRateT = 0f;
            shotCountC = 0;
            playerInZone = true;
        }
    } 
    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            cooldownT = 0f;
            fireRateT = 0f;
            shotCountC = 0;
            playerInZone = false;
            isAttacking = false;
        }
    }

    void Shoot()
    {
        if (projectilePrefab != null && firePoint != null)
        {
            Instantiate(projectilePrefab, firePoint.position, transform.rotation);
        }
    }

    void FacePlayer()
    {
        Vector3 direction = player.position - transform.position;
        float angleCible = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;
        Quaternion rotationCible = Quaternion.Euler(0, 0, angleCible);
        transform.rotation = Quaternion.RotateTowards(transform.rotation, rotationCible, rotationSpeed * globalTime.active * Time.deltaTime);
    }
}
