using UnityEngine;

public class BatteryManager : MonoBehaviour
{
    private PlayerTimer playerTimer;

    public void ShowBattery(int charge)
    {
        int i;
        for (i = 0; i < transform.childCount; i++)
        {
            if (i <  charge)
            {
                transform.GetChild(i).gameObject.SetActive(true);
            }
            else
            {
                transform.GetChild(i).gameObject.SetActive(false);
            }
        }
    }
    void Start()
    {
        playerTimer = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerTimer>();
    }

    // Update is called once per frame
    void Update()
    {

    }
}
