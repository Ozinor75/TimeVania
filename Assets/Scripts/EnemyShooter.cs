using UnityEngine;
using System.Collections;

public class EnemyShooter : MonoBehaviour
{
    public GlobalTime globalTime;
    public float timeScale;
    
    [Header("Cible & Tir")]
    public GameObject projectilePrefab;
    public Transform firePoint; 

    [Header("Paramètres de l'ennemi")]
    public float tempsObservation = 3f; 
    public int nombreDeTirs = 3; 
    public float delaiEntreTirs = 0.5f; 

    [Header("Vitesses")]
    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;
    
    [Header("Vitesse de rotation")]
    public float vitesseRotation = 200f;
    
    private Transform player;
    private bool joueurDansZone = false;
    private bool estEnTrainDAttaquer = false;
    private Coroutine attaqueCoroutine;

    void Start()
    {
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
    }
    
    void Update()
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
        if (joueurDansZone && player != null)
        {
            FaireFaceAuJoueur();
        }
    }
    
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            Debug.Log(collision.gameObject.name);
            player = collision.transform;
            joueurDansZone = true;
            if (!estEnTrainDAttaquer)
            {
                attaqueCoroutine = StartCoroutine(BoucleAttaque());
            }
        }
    } 
    
    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            joueurDansZone = false;
            if (attaqueCoroutine != null)
            {
                StopCoroutine(attaqueCoroutine);
                estEnTrainDAttaquer = false;
            }
        }
    }

    IEnumerator BoucleAttaque()
    {
        estEnTrainDAttaquer = true;
        yield return new WaitForSeconds(tempsObservation*timeScale);
        if (joueurDansZone)
        {
            for (int i = 0; i < nombreDeTirs; i++)
            {
                if (!joueurDansZone) break; 
                Tirer();
                yield return new WaitForSeconds(delaiEntreTirs*timeScale);
            }
        }
        estEnTrainDAttaquer = false;
        if (joueurDansZone)
        {
            attaqueCoroutine = StartCoroutine(BoucleAttaque());
        }
    }

    void Tirer()
    {
        if (projectilePrefab != null && firePoint != null)
        {
            Instantiate(projectilePrefab, firePoint.position, Quaternion.identity);
        }
    }

    void FaireFaceAuJoueur()
    {
        Vector3 direction = player.position - transform.position;
        float angleCible = Mathf.Atan2(direction.y, direction.x) * Mathf.Rad2Deg;
        Quaternion rotationCible = Quaternion.Euler(0, 0, angleCible);
        transform.rotation = Quaternion.RotateTowards(transform.rotation, rotationCible, vitesseRotation * timeScale * Time.deltaTime);
    }
}
