using System;
using System.IO;
using UnityEditor.Overlays;
using UnityEngine;

public class SaveSystem : MonoBehaviour
{
    private static SaveData saveData = new SaveData();
    public PlayerSave playerSave;

    [System.Serializable]
    public struct SaveData
    {
        public PlayerSaveData playerSaveData;
    }

    public static string SaveFileName()
    {
        string saveFile = Application.persistentDataPath + "/save" + ".json";
        return saveFile;
    }

    public static void Save()
    {
        HandleSaveData();
        
        File.WriteAllText(SaveFileName(), JsonUtility.ToJson(saveData, true));
    }

    private static void HandleSaveData()
    {
        PlayerSave playerSave = FindFirstObjectByType<PlayerSave>();
        Debug.Log("TEST SAVE");
        playerSave.Save(ref saveData.playerSaveData);
        Debug.Log("LAST STATION = " + saveData.playerSaveData.lastStation.x + ", " + saveData.playerSaveData.lastStation.y);
    }

    public static void Load()
    {
        string saveContent = File.ReadAllText(SaveFileName());

        saveData = JsonUtility.FromJson<SaveData>(saveContent);
        HandleLoadData();
    }

    private static void HandleLoadData()
    {
        PlayerSave playerSave = FindFirstObjectByType<PlayerSave>();
        playerSave.Load(saveData.playerSaveData);
    }
}
