using UnityEngine;
using UnityEngine.Events;

public class Missile : MonoBehaviour
{
    private GlobalTime globalTime;
    private WorldEvents worldEvents;
    
    [Header("Projectile Parameters")]
    public float timeBeforeExplode;
    
    private float t;
    private PlayerController PlayerController;
    private bool hasBeenTouched = false;
    
    void Start()
    {
        globalTime = FindFirstObjectByType<GlobalTime>();
        worldEvents = FindFirstObjectByType<WorldEvents>();
        t = timeBeforeExplode;
    }

    void Update()
    {
        transform.position += transform.right * globalTime.active * Time.deltaTime;
        
        if (hasBeenTouched)
        {
            t -= Time.deltaTime * globalTime.active;
            if (t <= 0)
            {
                //ICI
                Destroy(gameObject);
            }
        }
    }
    private void OnCollisionEnter2D(Collision2D collision)
    {
        worldEvents.missileDestroyed.Invoke();
        hasBeenTouched = true;
    }

}
