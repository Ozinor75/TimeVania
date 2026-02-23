using UnityEngine;

public enum ObjectType
{
    powerUp,
    energyPlatform,
    baseEnemy,
    movingPlatform
}
public class Spawner : MonoBehaviour
{
    [Header("Objects Prefabs")]
    public GameObject energyPlatformPrefab;
    public GameObject movingPlatformPrefab;
    public GameObject powerUpPrefab;
    public GameObject baseEnemyPrefab;
    
    [Header("Object Type")]
    public ObjectType objectType;
    private GameObject go;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        Spawn();
    }

    public void Spawn()
    {
        if (go != null) return;
        switch (objectType)
        {
            case ObjectType.powerUp:
                go = Instantiate(powerUpPrefab, transform.position, Quaternion.identity);
                break;
            case ObjectType.energyPlatform:
                go = Instantiate(energyPlatformPrefab, transform.position, Quaternion.identity);
                break;
            case ObjectType.baseEnemy:
                go = Instantiate(baseEnemyPrefab, transform.position, Quaternion.identity);
                break;            
            case ObjectType.movingPlatform:
                go = Instantiate(movingPlatformPrefab, transform.position, Quaternion.identity);
                break;
        }
        go.transform.parent = transform;
    }
}
