using UnityEngine;

public class PlayerSave : MonoBehaviour
{
    private PlayerController playerController;
    private PlayerTimer playerTimer;

    public void Save(ref PlayerSaveData data)
    {
        data.lastStation = new Vector2(playerController.respawnPoint.position.x, playerController.respawnPoint.position.y);
        data.batterySizeBoost = playerTimer.batterySizeBoost;
        data.powerUpAbsorptionBoost = playerTimer.powerUpAbsorptionBoost;
    }

    public void Load(PlayerSaveData data)
    {
        Debug.Log("PLAYER POSITION DATA = " +  data.lastStation.x + "," + data.lastStation.y + "," + data.batterySizeBoost);
        playerController.transform.position = data.lastStation;
        playerTimer.batterySizeBoost = data.batterySizeBoost;
        playerTimer.powerUpAbsorptionBoost = data.powerUpAbsorptionBoost;
    }
    void Start()
    {
        playerController = FindFirstObjectByType<PlayerController>();
        playerTimer = FindFirstObjectByType<PlayerTimer>();
    }
    

    // Update is called once per frame
    void Update()
    {
        
    }
}

[System.Serializable]

public struct PlayerSaveData
{
    public Vector2 lastStation;
    public int batterySizeBoost;
    public int powerUpAbsorptionBoost;
}
