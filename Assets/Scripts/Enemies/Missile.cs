using UnityEngine;

public class Missile : MonoBehaviour
{
    public GlobalTime globalTime;
    
    [Header("Projectile Parameters")]
    public float timeBeforeExplode;
    
    private float t;
    private PlayerController PlayerController;
    private bool hasBeenTouched = false;
    
    void Start()
    {
        globalTime = FindFirstObjectByType<GlobalTime>();
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
                Destroy(gameObject);
            }
        }
    }
    private void OnCollisionEnter2D(Collision2D collision)
    {
        hasBeenTouched = true;
    }

}
