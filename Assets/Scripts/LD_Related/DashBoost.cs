using UnityEngine;

public class DashBoost : MonoBehaviour
{
    private CharacterMeshControler meshControler;
    private PlayerSound playerSound;
    private PlayerFeedback playerFeedback;
    private PlayerController playerController;
    private PlayerTimer playerTimer;
    private BatteryManager batteryManager;
    
    public GameObject buttonUI;
    public bool onTrigger;
    public bool isUsed;
    
    void Start()
    {
        meshControler = FindFirstObjectByType<CharacterMeshControler>();
        playerController = FindFirstObjectByType<PlayerController>();
        playerSound = FindFirstObjectByType<PlayerSound>();
        playerTimer = FindFirstObjectByType<PlayerTimer>();
        playerFeedback = FindFirstObjectByType<PlayerFeedback>();
        batteryManager = FindFirstObjectByType<BatteryManager>();
    }

    public void MakeBoost()
    {
        if (!isUsed)
        {
            meshControler.SetDashHelmet();
            playerController.canDash = true;
            isUsed = true;
            SaveSystem.Save();
            playerController.boostTrigger = null;
            buttonUI.SetActive(false);
        }
    }
    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.gameObject.CompareTag("Player") && !isUsed)
        {
            onTrigger = true;
            playerController.boostTrigger = transform;
            buttonUI.SetActive(true);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        onTrigger = false;
        playerController.boostTrigger = null;
        buttonUI.SetActive(false);
    }
}
