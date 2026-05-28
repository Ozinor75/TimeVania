using UnityEngine;

public class PlayerSave : MonoBehaviour
{
    private PlayerController playerController;
    private PlayerTimer playerTimer;
    private BatteryManager batteryManager;

    public void Save(ref PlayerSaveData data)
    {
        playerController.savePoint = playerController.respawnPoint.position;
        data.lastStation = playerController.savePoint;
        data.canDash = playerController.canDash;
        data.activeLevel = batteryManager.activeLevel;
        data.starLevel = batteryManager.starLevel;
    }

    public void Load(PlayerSaveData data)
    {
        Debug.Log("PLAYER POSITION DATA = " +  data.lastStation.x + "," + data.lastStation.y + "," + data.activeLevel + "," + data.starLevel);
        //playerController.transform.position = data.lastStation;
        playerController.respawnPoint.position = data.lastStation;
        playerController.canDash =  data.canDash;
        batteryManager.activeLevel = data.activeLevel;
        batteryManager.starLevel = data.starLevel;
        batteryManager.UpdateBattery();
    }
    void Start()
    {
        playerController = FindFirstObjectByType<PlayerController>();
        playerTimer = FindFirstObjectByType<PlayerTimer>();
        batteryManager = FindFirstObjectByType<BatteryManager>();
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
    public bool canDash;
    public int activeLevel;
    public int starLevel;
}
