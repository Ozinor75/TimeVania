using UnityEditor;
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
    
    [Header("Passive Actions")]
    private bool isMoving;
    public UnityEvent Movement;
    public UnityEvent StopMovement;

    public CustomInputs playerControls;
    private PlayerController playerController;
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
    }

    // Update is called once per frame
    void Update()
    {
        if (playerControls.Player.Direction.ReadValue<Vector2>() != Vector2.zero && !isMoving)
        {
            if (playerController.isGrounded)
            {
                Movement.Invoke();
                isMoving = true;
            }
        }

        if (!(playerControls.Player.Direction.ReadValue<Vector2>() != Vector2.zero) && isMoving)
        {
            {
                isMoving = false;
                StopMovement.Invoke();
            }
        }
        
        if (playerControls.Player.Jump.WasPressedThisFrame())
        {
            if (playerController.isGrounded || playerController.coyotE > 0f)
            {
                Debug.Log("Jumping");
                // EditorApplication.isPaused = true;
                Jump.Invoke();
            }
        }

        if (playerControls.Player.Dash.WasPressedThisFrame() && playerController.timerController.t > playerController.dashCost)
        {
            Debug.Log("Dashing");
            Dash.Invoke();
        }

        if (playerControls.Player.Upgrade.WasPressedThisFrame() && playerController.activePreset == PlayerPresets.Mid)
        {
            Debug.Log("Upgrading");
            playerController.gearChange = 2;
            Upgrade.Invoke();
        }
        
        if (playerControls.Player.Downgrade.WasPressedThisFrame() && playerController.activePreset == PlayerPresets.Mid)
        {
            Debug.Log("Downgrading");
            playerController.gearChange = 0;
            Downgrade.Invoke();
        }
        
        if (playerControls.Player.Upgrade.WasReleasedThisFrame() || playerControls.Player.Downgrade.WasReleasedThisFrame())
        {
            Debug.Log("Gear Released");
            playerController.gearChange = 1;
            GearReleased.Invoke();
        }

        if (playerControls.Player.Station.WasPressedThisFrame() && playerController.onStation && !playerController.isCharging)
        {
            Debug.Log("Station Pressed");
            playerController.isCharging = true;
            ActivateStation.Invoke();
        }
    }
}
