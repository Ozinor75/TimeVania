using UnityEngine;

public enum ObjectType
{
    powerUp6,
    powerUp12,
    powerUp24,
    baseEnemy,
    // energyPlatform,
    // movingPlatform
}
public class Spawner : MonoBehaviour
{
    [Header("Objects Prefabs")]
    public GameObject powerUpPrefab6;
    public GameObject powerUpPrefab12;
    public GameObject powerUpPrefab24;
    public GameObject baseEnemyPrefab;
    // public GameObject energyPlatformPrefab;
    // public GameObject movingPlatformPrefab;
    
    [Header("Object Type")]
    public ObjectType objectType;
    private GameObject go;
    
    void Start()
    {
        Spawn();
    }

    public void Spawn()
    {
        if (go != null) return;
        
        
        switch (objectType)
        {
            case ObjectType.powerUp6:
                go = Instantiate(powerUpPrefab6, transform.position, Quaternion.identity);
                break;            
            case ObjectType.powerUp12:
                go = Instantiate(powerUpPrefab12, transform.position, Quaternion.identity);
                break;            
            case ObjectType.powerUp24:
                go = Instantiate(powerUpPrefab24, transform.position, Quaternion.identity);
                break;
            case ObjectType.baseEnemy:
                go = Instantiate(baseEnemyPrefab, transform.position, Quaternion.identity);
                break;
            // case ObjectType.energyPlatform:
            //     go = Instantiate(energyPlatformPrefab, transform.position, Quaternion.identity);
            //     break;
            // case ObjectType.movingPlatform:
            //     go = Instantiate(movingPlatformPrefab, transform.position, Quaternion.identity);
            //     break;
        }
        go.transform.parent = transform;
    }
}
