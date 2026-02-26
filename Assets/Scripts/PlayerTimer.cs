using TMPro;
using UnityEngine;
using TMPro;

public enum TimeState
{
    ChargeOne,
    ChargeTwo,
    ChargeThree,
    ChargeFour,
    ChargeFive,
    ChargeSix,
    ChargeSeven,
    ChargeEight,
    ChargeNine,
    ChargeTen
}

public class PlayerTimer : MonoBehaviour
{
    public float timer;
    public float maxTimer;
    public float criticalTimer;
    public float t;
    public float tMult;
    public TextMeshProUGUI text;
    public TimeState charge;

    private float tSec = 0f;
    private Spawner[] spawner;
    private EnergyPlatform[] energy;
    private BatteryManager batteryManager;
    
    public Material energyMaterial;

    public int CheckCharge()
    {
        float timeCheck = (t / timer) * 10f;
        int charge = Mathf.CeilToInt(timeCheck);
        return charge;
    }
    void Start()
    {
        spawner = FindObjectsOfType<Spawner>();
        energy = FindObjectsOfType<EnergyPlatform>();
        batteryManager = FindObjectOfType<BatteryManager>();
        t = timer;
        charge = TimeState.ChargeTen;
    }
    
    void Update()
    {
        t -= Time.deltaTime * tMult;
        tSec += Time.deltaTime;
        if (t > criticalTimer)
            text.text = t.ToString("0");
        else
            text.text = t.ToString("0.00");

        if (t <= 0)
        {
            foreach (Spawner sp in spawner)
            {
                sp.Spawn();
            }

            foreach (EnergyPlatform ep in energy)
            {
                ep.isUsed = false;
                ep.isRespawned = true;
            }
        }

        if (tSec >= 1f)
        {
            batteryManager.ShowBattery(CheckCharge());
            tSec = 0f;
        }
        // if (t <= 0f)
        // {
        //     tMult = 0;      // en vrai faudra pas faire ça, mais c'est juste que pr le moment on remonte pas le temps
        //     Debug.Log("OUTTA TIME !!!");
        // }
    }

    
}
