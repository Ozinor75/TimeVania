using UnityEngine;

public class BoostSave : MonoBehaviour
{
    private DashBoost dashBoost;
    private BatterySizeBoost batterySizeBoost;
    private AbsorptionBoost absorptionBoost;

    public int i;
    private bool isSize;
    private bool isDash;
    public void Save(ref BoostSaveData data)
    {
        if (isDash)
            data.isUsed[i] = dashBoost.isUsed;
        else if (isSize)
            data.isUsed[i] = batterySizeBoost.isUsed;
        else
            data.isUsed[i] = absorptionBoost.isUsed;
    }

    public void Load(BoostSaveData data)
    {
        if (isDash)
        {
            dashBoost.isUsed = data.isUsed[i];
        }
        else if (isSize)
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
        else if (transform.CompareTag("AbsorptionBoost"))
        {
            absorptionBoost = GetComponent<AbsorptionBoost>();
            isSize = false;
        }
        else
        {
            dashBoost = GetComponent<DashBoost>();
            isDash = true;
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
