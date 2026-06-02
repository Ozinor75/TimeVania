using UnityEngine;

using System;
using System.IO;
// using UnityEditor.Overlays; ça empêche de build

public class SaveSystem : MonoBehaviour
{
    private static SaveData saveData = new SaveData();
    public PlayerSave playerSave;
    public BoostSave boostSave;

    [System.Serializable]
    public struct SaveData
    {
        public PlayerSaveData playerSaveData;
        public BoostSaveData boostSaveData;
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
        BoostSave[] boostSave = FindObjectsOfType<BoostSave>();
        // Debug.Log("TEST SAVE");
        saveData.boostSaveData.isUsed = new bool[boostSave.Length];
        playerSave.Save(ref saveData.playerSaveData);
        for (int i = 0; i < boostSave.Length; i++)
        {
            boostSave[i].i = i;
            boostSave[i].Save(ref saveData.boostSaveData);
        }
        // Debug.Log("LAST STATION = " + saveData.playerSaveData.lastStation.x + ", " + saveData.playerSaveData.lastStation.y);
    }

    public static void Load()
    {
        // Debug.Log("TEST LOAD");
        string saveContent = File.ReadAllText(SaveFileName());

        saveData = JsonUtility.FromJson<SaveData>(saveContent);
        HandleLoadData();
    }

    private static void HandleLoadData()
    {
        PlayerSave playerSave = FindFirstObjectByType<PlayerSave>();
        BoostSave[] boostSave = FindObjectsOfType<BoostSave>();
        playerSave.Load(saveData.playerSaveData);
        for (int i = 0; i < boostSave.Length; i++)
        {
            boostSave[i].i = i;
            boostSave[i].Load(saveData.boostSaveData);
        }
    }
}
