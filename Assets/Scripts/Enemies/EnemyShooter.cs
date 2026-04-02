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
    public int shotCount = 3; 
    public float fireRate = 0.5f; 
    
    [Header("Rotation Speed")]
    public Transform player;
    private Coroutine attackCouroutine;
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
            
            playerInZone = true;
            
            if (!isAttacking)
            {
                attackCouroutine = StartCoroutine(AttackCourountine());
            }
        }
    } 
    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            playerInZone = false;
            if (attackCouroutine != null)
            {
                StopCoroutine(attackCouroutine);
                isAttacking = false;
            }
        }
    }

    IEnumerator AttackCourountine()
    {
        isAttacking = true;
        
        yield return new WaitForSeconds(cooldown / globalTime.active);  // CHANGER WAITFORSECONDS
        
        for (int i = 0; i < shotCount; i++)
        {
            if (!playerInZone) break; 
            Shoot();
            yield return new WaitForSeconds(fireRate / globalTime.active);
        }
        isAttacking = false;
        
        if (playerInZone)
        {
            attackCouroutine = StartCoroutine(AttackCourountine());
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
