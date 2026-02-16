using UnityEngine;

public enum ObjectType
{
    powerUp,
    energyPlatform
}
public class Spawner : MonoBehaviour
{
    [Header("Objects Prefabs")]
    public GameObject energyPlatformPrefab;
    public GameObject powerUpPrefab;
    
    [Header("Object Type")]
    public ObjectType objectType;
    private GameObject go;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        Spawn();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Spawn()
    {
        switch (objectType)
        {
            case ObjectType.powerUp:
                go = Instantiate(powerUpPrefab, transform.position, Quaternion.identity);
                break;
            case ObjectType.energyPlatform:
                go = Instantiate(energyPlatformPrefab, transform.position, Quaternion.identity);
                break;
        }
        go.transform.parent = transform;
    }
}
