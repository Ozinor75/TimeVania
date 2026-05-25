using UnityEngine;

public class SpawingPlatform : MonoBehaviour
{
    [Header("Spawn")]
    public GlobalTime manager;
    public float timeToSpawn;
    
    [Header("Boundaries")]
    public Transform start;
    public Transform end;
    
    [Header("Platform")]
    public GameObject platform;
    public AnimationCurve movementCurve;
    public float trackDuration;
    private GameObject go;
    private float t;

    [Header("DA")]
    public Light spawnLight;
    
    private void Start()
    {
        spawnLight.enabled = false;
        manager = FindFirstObjectByType<GlobalTime>();
    }
    
    void Update()
    {
        t += Time.deltaTime * manager.active;

        if (t >= timeToSpawn * (8 / 10))
            spawnLight.enabled = true;
        
        if (t >= timeToSpawn)
        {
            Spawn();
            t = 0;
            spawnLight.enabled = false;
        }
    }

    private void Spawn()
    {
        go = Instantiate(platform, transform.position, Quaternion.identity);
        go.transform.position = start.position;
        go.transform.parent = transform;
        go.GetComponent<MovingAndDestroy>().start = start;
        go.GetComponent<MovingAndDestroy>().end = end;
        go.GetComponent<MovingAndDestroy>().manager = manager;
        go.GetComponent<MovingAndDestroy>().duration = trackDuration;
        go.GetComponent<MovingAndDestroy>().curve = movementCurve;
        
    }
}
