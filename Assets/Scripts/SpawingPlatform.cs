using UnityEngine;

public class SpawingPlatform : MonoBehaviour
{
    public enum ObjectType
    {
        UpPlatform,
        DownPlatform,
        RightPlatform,
        LeftPlatform
    }
    
    [Header("Instantiate")]
    public GameObject UpPlatform;
    public GameObject DownPlatform;
    public GameObject RightPlatform;
    public GameObject LeftPlatform;
    
    public GlobalTime globalTime;
    public float timeScale;
    public float timeToSpawn;

    public float acceleratedTime;
    public float normalTime = 1f;
    public float slowedTime;
    
    public ObjectType objectType;
    private GameObject go;
    private bool CanSpawn = true;
    private float timer;

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
        timer += Time.deltaTime*timeScale;
        if (timer >= timeToSpawn)
        {
            CanSpawn = true;
        }
        if (CanSpawn)
        {
            Spawn();
            timer = 0;
            CanSpawn = false;
        }
    }

    private void Spawn()
    {
        switch (objectType)
        {
            case ObjectType.UpPlatform:
                go = Instantiate(UpPlatform, transform.position, Quaternion.identity);
                break;            
            case ObjectType.DownPlatform:
                go = Instantiate(DownPlatform, transform.position, Quaternion.identity);
                break;            
            case ObjectType.RightPlatform:
                go = Instantiate(RightPlatform, transform.position, Quaternion.identity);
                break;
            case ObjectType.LeftPlatform:
                go = Instantiate(LeftPlatform, transform.position, Quaternion.identity);
                break;
        }
        go.transform.parent = transform;
    }

    private void Start()
    {
        globalTime = FindAnyObjectByType<GlobalTime>();
        timeScale = normalTime;
    }
}
