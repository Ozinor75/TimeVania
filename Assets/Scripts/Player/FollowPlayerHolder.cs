using UnityEngine;
using UnityEngine.Serialization;

public class FollowPlayerHolder : MonoBehaviour
{
    public Transform PlayerPos;
    public PlayerController PlayerController;
    public CustomInputs playerControls;

    [Header("X Axis")]
    public float offset = 3f;
    public float smoothTimeX = 0.25f;
    private float velocityX = 0f;
    private float targetOffsetX = 0f;

    [Header("Y Axis")]
    public float offsetY = 10f;
    public float smoothTimeY = 0.3f; 
    public float timeUp = 0.5f;      
    public float Ytolérance = 70f;

    private float velocityY = 0f;
    private float timer;
    private bool isRecovering = false;

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
    
    void Update()
    {   
        float inputX = playerControls.Player.Direction.ReadValue<Vector2>().x;
        if (inputX > 0.1f)
            targetOffsetX = -offset;
        else if (inputX < -0.1f)
            targetOffsetX = offset;
        else
            targetOffsetX = 0f;

        float targetX = PlayerPos.position.x + targetOffsetX;
        float newX = Mathf.SmoothDamp(transform.position.x, targetX, ref velocityX, smoothTimeX);
        float targetY = PlayerPos.position.y;
        float newY = transform.position.y;

        if (PlayerController.isGrounded)
        {
            if (timer < 0f || isRecovering)
            {
                isRecovering = true;
                timer = timeUp;
            }

            if (isRecovering)
            {
                newY = Mathf.SmoothDamp(transform.position.y, targetY, ref velocityY, smoothTimeY);
                
                if (Mathf.Abs(transform.position.y - targetY) < 0.05f)
                {
                    isRecovering = false;
                    newY = targetY;
                    velocityY = 0f;
                }
            }
            else
            {
                newY = targetY;
                velocityY = 0f;
                timer = timeUp;
            }
        }
        else
        {
            timer -= Time.deltaTime;

            if (timer < 0f)
            {
                float downTargetY = targetY - offsetY;
                newY = Mathf.SmoothDamp(transform.position.y, downTargetY, ref velocityY, smoothTimeY);
            }
            else
            {
                if (isRecovering)
                {
                    newY = Mathf.SmoothDamp(transform.position.y, targetY, ref velocityY, smoothTimeY);
                }
                else
                {
                    newY = targetY;
                    velocityY = 0f;
                }
            }
        }
        transform.position = new Vector3(newX, newY, 0f);
    }
}