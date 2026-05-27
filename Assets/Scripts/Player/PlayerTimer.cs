using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
public class PlayerTimer : MonoBehaviour
{
    public float timer;
    public float maxTimer;
    public float criticalTimer;

    public float chargingSpeed;
    
    public float batteryBoostValue;
    public float powerUpAbsorptionBoostValue;
    
    [Header("Debug")]
    public int batterySizeBoost;
    public int powerUpAbsorptionBoost;
    
    public float t;
    public float tMult;
    private float MultDeMult;
    public TextMeshProUGUI text;

    private float tSec = 0f;
    public bool isCharging = false;
    private Spawner[] spawner;
    private BatteryManager batteryManager;
    
    public Material energyMaterial;

    public int CheckCharge()
    {
        float timeCheck = (t / timer) * 10f;
        int charge = Mathf.CeilToInt(timeCheck);
        return charge;
    }

    private IEnumerator Charging()
    {
        while (t < timer)
        {
            t = t + chargingSpeed;
            yield return null;
        }

        if (t > timer)
            t = timer;
        yield break;
    }

    public void StartCharging()
    {
        isCharging = true;
        StartCoroutine(Charging());
    }

    public void StopCharging()
    {
        isCharging = false;
    }

    public void ChangeTime(float value, bool isPositive)
    {
        if (isPositive)
            t += value;
        else
            t -= value;
    }
    void Start()
    {
        spawner = FindObjectsOfType<Spawner>();
        batteryManager = FindObjectOfType<BatteryManager>();
        t = timer;
        DivideMult();
    }
    
    void Update()
    {
        if (t < 0f)
            t = 0f;
        
        if (!isCharging && t > 0f)
            t -= Time.deltaTime * tMult * MultDeMult;
        
        tSec += Time.deltaTime;

        // if (t > maxTimer) faire marcher ça, prcq ça s'appelle en boucle
        // {
        //     t = maxTimer;
        //     Debug.Log("MaxTimer");
        // }
        
        // if (t > criticalTimer)
        //     text.text = t.ToString(" ");
        //
        // else
        //     text.text = t.ToString("0.00");

        if (t <= 0)
        {
            foreach (Spawner sp in spawner)
            {
                sp.Spawn();
            }
        }
        Debug.Log(MultDeMult*tMult);

        // if (tSec >= 0.2f)
        // {
        //     batteryManager.ShowBattery(CheckCharge());
        //     tSec = 0f;
        // }
    }

    public void DivideMult()
    {
        MultDeMult = 0.5f;
    }

    public void MultiplyMult()
    {
        MultDeMult = 1f;
        // Debug.Log(tMult);
    }

    public void TimerNull()
    {
        tMult *= 10f;
    }
}
