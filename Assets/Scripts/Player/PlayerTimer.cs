using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using TMPro;
public class PlayerTimer : MonoBehaviour
{
    public float timer;
    public float maxTimer;
    public float criticalTimer;
    public float t;
    public float tMult;
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
            t++;
            // yield return new WaitForSeconds(0.1f);
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
    void Start()
    {
        spawner = FindObjectsOfType<Spawner>();
        batteryManager = FindObjectOfType<BatteryManager>();
        t = timer;
    }
    
    void Update()
    {
        if (t < 0f)
            t = 0f;
        
        if (!isCharging && t > 0f)
            t -= Time.deltaTime * tMult;
        
        tSec += Time.deltaTime;
        
        if (t > criticalTimer)
            text.text = t.ToString(" ");
        
        else
            text.text = t.ToString("0.00");

        if (t <= 0)
        {
            foreach (Spawner sp in spawner)
            {
                sp.Spawn();
            }
        }

        // if (tSec >= 0.2f)
        // {
        //     batteryManager.ShowBattery(CheckCharge());
        //     tSec = 0f;
        // }
    }
}
