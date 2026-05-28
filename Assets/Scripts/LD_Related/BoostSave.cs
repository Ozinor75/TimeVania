using UnityEngine;

public class BoostSave : MonoBehaviour
{
    private BatterySizeBoost batterySizeBoost;
    private AbsorptionBoost absorptionBoost;

    public int i;
    private bool isSize;
    public void Save(ref BoostSaveData data)
    {
        if (isSize)
            data.isUsed[i] = batterySizeBoost.isUsed;
        else
            data.isUsed[i] = absorptionBoost.isUsed;
    }

    public void Load(BoostSaveData data)
    {
        if (isSize)
        {
            Debug.Log("SIZE LOAD");
            batterySizeBoost.isUsed = data.isUsed[i];
        }
        else
        {
            Debug.Log("ABSORPTION LOAD");
            absorptionBoost.isUsed = data.isUsed[i];
        }
    }
    void Start()
    {
        if (transform.CompareTag("SizeBoost"))
        {
            batterySizeBoost = GetComponent<BatterySizeBoost>();
            isSize = true;
        }
        else
        {
            absorptionBoost = GetComponent<AbsorptionBoost>();
            isSize = false;
        }
    }
    

    // Update is called once per frame
    void Update()
    {
        
    }
}

[System.Serializable]

public struct BoostSaveData
{
    public bool[] isUsed;
}
