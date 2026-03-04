using UnityEngine;
using UnityEngine.UI;

public class BatteryManager : MonoBehaviour
{
    private PlayerTimer playerTimer;
    private BatterySound batterySound;
    private Color batteryColor;
    public void ShowBattery(int charge)
    {
        int i;
        if (charge >= 7)
            batteryColor = Color.green;
        else if (charge >= 4)
            batteryColor = Color.yellow;
        else
            batteryColor = Color.red;
        for (i = 0; i < transform.childCount; i++)
        {
            if (i <  charge)
            {
                transform.GetChild(i).gameObject.SetActive(true);
                transform.GetChild(i).GetComponent<Image>().color = batteryColor;
            }
            else
            {
                if (transform.GetChild(i).gameObject.activeSelf)
                {
                    batterySound.LoseCharge();
                    transform.GetChild(i).gameObject.SetActive(false);
                }
            }
        }

        if (playerTimer.t <= playerTimer.criticalTimer)
        {
            batterySound.TickingTimer(true);
        }
        else
        {
            batterySound.TickingTimer(false);
        }
    }
    void Start()
    {
        playerTimer = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerTimer>();
        batterySound = GetComponent<BatterySound>();
    }

    // Update is called once per frame
    void Update()
    {

    }
}
