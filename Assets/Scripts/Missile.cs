using UnityEngine;

public class Missile : MonoBehaviour
{
    public GlobalTime globalTime;
    public float timeScale;
    
    [Header("Paramètres du Projectile")]
    public float tempsDeVie = 4f; 

    [Header("Vitesses")]
    public float acceleratedTime;
    public float normalTime;
    public float slowedTime;
    
    private bool destroying = false;
    private Vector3 directionDeTir;
    private float t = 0.5f;
    void Start()
    {
        Destroy(gameObject, tempsDeVie);
        GameObject joueur = GameObject.FindGameObjectWithTag("Player");
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
        if (joueur != null)
        {
            directionDeTir = (joueur.transform.position - transform.position).normalized;
            float angle = Mathf.Atan2(directionDeTir.y, directionDeTir.x) * Mathf.Rad2Deg;
            transform.rotation = Quaternion.Euler(0, 0, angle);
        }
        else
        {
            directionDeTir = Vector3.right;
        }
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
        transform.position += directionDeTir * timeScale * Time.deltaTime;
        if (destroying)
        {
            t -= Time.deltaTime*timeScale;
            if (t <= 0)
            {
                Destroy(gameObject);
            }
        }
    }
    private void OnCollisionEnter2D(Collision2D collision)
    {
        Debug.Log(collision.gameObject.tag);
        destroying =  true;
    }
}
