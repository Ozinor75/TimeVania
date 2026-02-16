using TMPro;
using UnityEngine;
using TMPro;

public class PlayerTimer : MonoBehaviour
{
    public float timer;
    public float criticalTimer;
    public float t;
    public float tMult;
    public TextMeshProUGUI text;
    
    private Spawner[] spawner;
    private EnergyPlatform[] energy;
    
    public Material energyMaterial;
    void Start()
    {
        spawner = FindObjectsOfType<Spawner>();
        energy = FindObjectsOfType<EnergyPlatform>();
        t = timer;
    }
    
    void Update()
    {
        t -= Time.deltaTime * tMult;
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
        // if (t <= 0f)
        // {
        //     tMult = 0;      // en vrai faudra pas faire ça, mais c'est juste que pr le moment on remonte pas le temps
        //     Debug.Log("OUTTA TIME !!!");
        // }
    }

    
}
