using UnityEngine;
using UnityEngine.Events;

public class InputManager : MonoBehaviour
{
    [Header("Active Actions")]
    public UnityEvent Jump;
    public UnityEvent Dash;
    public UnityEvent Upgrade;
    public UnityEvent Downgrade;
    public UnityEvent GearReleased;
    public UnityEvent ActivateStation;
    public UnityEvent FinalStation;
    public UnityEvent AutoDestroy;
    public UnityEvent UseHook;
    
    [Header("Passive Actions")]
    private bool isMoving;
    public UnityEvent Movement;
    public UnityEvent StopMovement;

    public CustomInputs playerControls;
    private PlayerController playerController;
    private PlayerTimer playerTimer;
    private bool IsDivided = true;
    private bool isMid = true;
    
    private void OnEnable()
    {
        if (playerControls == null)
            playerControls = new CustomInputs();
        
        playerControls.Enable();
    }
    private void OnDisable()
    {
        playerControls.Disable();
    }
    void Start()
    {
        playerController = FindAnyObjectByType<PlayerController>();
        playerTimer = FindAnyObjectByType<PlayerTimer>();
    }

    // Update is called once per frame
    void Update()
    {
        if (playerControls.Player.Direction.ReadValue<Vector2>() != Vector2.zero && !isMoving)
        {
            if (playerController.isGrounded)
            {
                if (IsDivided)
                {
                    Movement.Invoke();
                    IsDivided =  false;
                }
                isMoving = true;
            }
        }
        
        if (!(playerControls.Player.Direction.ReadValue<Vector2>() != Vector2.zero) && isMoving)
        {
            {
                if (!IsDivided)
                {
                    StopMovement.Invoke();
                    IsDivided = true;
                }
                isMoving = false;
            }
        }
        
        if (playerControls.Player.Jump.WasPressedThisFrame())
        {
            // Debug.Log("Jumping");
            Jump.Invoke();
        }

        if (playerControls.Player.Dash.WasPressedThisFrame() && playerController.timerController.t > playerController.dashCost && playerControls.Player.Direction.ReadValue<Vector2>() != Vector2.zero && playerController.canDash)
        {
            // Debug.Log("Dashing");
            Dash.Invoke();
        }

        bool isUpgradeHeld = playerControls.Player.Upgrade.IsPressed();
        bool isDowngradeHeld = playerControls.Player.Downgrade.IsPressed();
        
        if (playerControls.Player.Upgrade.WasPressedThisFrame())
        {
            Upgrade.Invoke();
            isMid = false;
        }
        else if (playerControls.Player.Downgrade.WasPressedThisFrame())
        {
            Downgrade.Invoke();
            isMid = false;
        }
        
        if (playerControls.Player.Upgrade.WasReleasedThisFrame())
        {
            if (isDowngradeHeld)
            {
                Downgrade.Invoke();
                isMid = false;
            }
        }        

        if (playerControls.Player.Downgrade.WasReleasedThisFrame())
        {
            if (isUpgradeHeld)
            {
                Upgrade.Invoke();
                isMid = false;
            }
        }
        
        if (!isUpgradeHeld && !isDowngradeHeld && !isMid)
        {
            isMid = true;
            GearReleased.Invoke();
        }

        if (playerControls.Player.Station.WasPressedThisFrame() && playerController.onStation && !playerController.isCharging)
        {
            // Debug.Log("Station Pressed");
            playerController.isCharging = true;
            ActivateStation.Invoke();
        }
        
        if (playerControls.Player.Station.WasPressedThisFrame() && playerController.onFinal)
        {
            // Debug.Log("Station Pressed");
            playerController.isCharging = true;
            FinalStation.Invoke();
        }
        
        if (playerControls.Player.Station.WasPressedThisFrame() && playerController.boostTrigger != null)
        {
            if (playerController.boostTrigger.CompareTag("SizeBoost"))
            {
                playerController.boostTrigger.GetComponent<BatterySizeBoost>().MakeBoost();
            }
            else if (playerController.boostTrigger.CompareTag("DashBoost"))
            {
                playerController.boostTrigger.GetComponent<DashBoost>().MakeBoost();
            }
            else
            {
                playerController.boostTrigger.GetComponent<AbsorptionBoost>().MakeBoost();
            }
        }
        
        if (playerControls.Player.Station.WasPressedThisFrame() && playerController.doorTrigger != null)
        {
            playerController.doorTrigger.GetComponent<DoorTrigger>().OpenDoor();
        }

        if (playerControls.Player.L3Click.IsPressed() && playerControls.Player.R3Click.IsPressed())
        {
            playerTimer.TimerNull();
        }
        
        if (playerControls.Player.Hook.WasPressedThisFrame())
        {
            UseHook.Invoke();
        }
        
        if (playerControls.Player.Save.WasPressedThisFrame())
        {
            SaveSystem.Save();
            Debug.Log("Save");
        }
        
        if (playerControls.Player.Load.WasPressedThisFrame())
        {
            SaveSystem.Load();
            Debug.Log("Load");
        } 
    }
}
