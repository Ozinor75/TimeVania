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
    public MeshRenderer LED_Part;
    private Material LED_Mat;
    
    private void Start()
    {
        spawnLight.enabled = false;
        manager = FindFirstObjectByType<GlobalTime>();
        LED_Mat = LED_Part.material;
    }
    
    void Update()
    {
        t += Time.deltaTime * manager.active;

        if (t >= timeToSpawn * 0.8f)
        {
            LED_Mat.SetFloat("_Ratio", 0f);
            spawnLight.enabled = true;
        }
            
        if (t >= timeToSpawn)
        {
            Spawn();
            spawnLight.enabled = false;
            LED_Mat.SetFloat("_Ratio", 1f);
            t = 0;
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
