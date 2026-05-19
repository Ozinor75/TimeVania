using UnityEngine;
using UnityEngine.Serialization;

public class FollowPlayerHolder : MonoBehaviour
{
    public Transform PlayerPos;
    public PlayerController PlayerController;
    public CustomInputs playerControls;
    public Vector3 targetPos;
    private Vector3 realVelocity = new Vector3(2, 0, 0) ;

    public float offset = 3f;
    public float offsetY = 10f;
    public float smoothTimeX = 0.25f;
    public float SpeedLerpY = 5f;
    private float LerpTimeY = 0f;
    public float Ytolérance = 70f;
    private float realOffset = 0f;
    private float realOffsetY = 0f;

    private float timer;
    public float timeUp;
    
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
        timer = timeUp;
    }
    
    // Update is called once per frame
    void Update()
    {   
        if (playerControls.Player.Direction.ReadValue<Vector2>().x > 0.1)
            realOffset = -offset;
        else if (playerControls.Player.Direction.ReadValue<Vector2>().x < -0.1)
            realOffset = offset;
        else
            realOffset = 0f;

        // float distanceY = PlayerPos.position.y - transform.position.y;

        if (!PlayerController.isGrounded) 
        {
            timer -= Time.deltaTime;
            if (timer < 0f)
            {
                Debug.Log("timer");
                LerpTimeY = 1f;
                realOffsetY = -offsetY;
            }
        }
        else
        {
            timer = timeUp;
            LerpTimeY = SpeedLerpY * Time.deltaTime; 
            realOffsetY = 0f;
        }
        
        targetPos = new Vector3(PlayerPos.position.x + realOffset, PlayerPos.position.y + realOffsetY, PlayerPos.position.z);
        
        float newX = Mathf.SmoothDamp(transform.position.x, targetPos.x, ref realVelocity.x, smoothTimeX);
        float newY = Mathf.Lerp(transform.position.y, targetPos.y, LerpTimeY);
        
        transform.position = new Vector3(newX, newY, 0f);
    }
}
